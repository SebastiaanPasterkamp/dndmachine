package policy

import (
	"context"
	"log"
	"net/http"
	"strings"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func IfAllowed(e *Enforcer, query string) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			input := getInput(r)

			allowed, err := e.Allow(r.Context(), query, input)
			if err != nil {
				log.Printf("ERROR: failed to check permission for %q: %v", query, err)
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
				return
			}

			if !allowed {
				log.Printf("WARN: permission denied for %q", input)
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}

func IfPossible(e *Enforcer, query string, unknowns []string) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ctx := r.Context()
			input := getInput(r)

			possible, clause, values, err := e.Partial(ctx, query, unknowns, input)
			if err != nil {
				log.Printf("ERROR: failed to check permission on %q with %q for %q (%q): %v",
					query, unknowns, clause, values, err)
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
				return
			}

			if !possible {
				log.Printf("WARN: permission denied on %q with %q for %q => %q (%q)",
					query, unknowns, input, clause, values)
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			}

			ctx = context.WithValue(ctx, Clause, clause)
			ctx = context.WithValue(ctx, Values, values)

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func getInput(r *http.Request) map[string]interface{} {
	user, _ := r.Context().Value(auth.CurrentUser).(*model.User)
	path := strings.Split(strings.Trim(r.URL.Path, "/"), "/")

	return map[string]interface{}{
		"path":   path,
		"method": "GET",
		"user":   user,
	}
}
