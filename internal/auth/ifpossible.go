package auth

import (
	"context"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

// IfPossible is a middleware policy enforcer that can execute partial
// evaluations. If an action _could_ be permitted, the context will reflect
// which SQL fields are accessible, and contain a WHERE clause with values. The
// handler can use this information to restrict the SQL statement.
func IfPossible(e *policy.Enforcer, query string, unknowns []string) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			ctx := r.Context()
			input := getInput(r)

			possible, sql, err := e.Partial(ctx, query, unknowns, input)
			if err != nil {
				log.Printf("ERROR: failed to check permission for %q with %q and %q as unknowns: %v",
					query, input, unknowns, err)
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
				return
			}

			if !possible {
				log.Printf("WARN: permission denied for %q with %q and %q as unknowns.",
					query, input, unknowns)
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			}

			ctx = context.WithValue(ctx, SQLColumns, sql.Fields)
			ctx = context.WithValue(ctx, SQLClause, sql.Clause)
			ctx = context.WithValue(ctx, SQLValues, sql.Values)

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}
