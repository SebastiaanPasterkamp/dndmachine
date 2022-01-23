package auth

import (
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func IfAllowed(e *policy.Enforcer, query string) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			input := getInput(r)

			allowed, err := e.Allow(r.Context(), query, input)
			if err != nil {
				log.Printf("ERROR: failed to check permission for %q with %q: %v",
					query, input, err)
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
				return
			}

			if !allowed {
				log.Printf("WARN: permission denied for %q with %q",
					query, input)
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}
