package auth

import (
	"context"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func IfPossible(e *policy.Enforcer, query string, unknowns []string) func(next http.Handler) http.Handler {
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

			ctx = context.WithValue(ctx, SQLClause, clause)
			ctx = context.WithValue(ctx, SQLValues, values)

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}
