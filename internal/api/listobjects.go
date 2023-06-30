package api

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// ListObjectsHandler returns zero or more object from the provided
// database.Operator using the columns, queries, and values provided by the
// IfPossible middleware.
func ListObjectsHandler(op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		columns := ctx.Value(auth.SQLColumns).([]string)
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		objs, err := op.GetByQuery(ctx, columns, clause, values...)
		if err != nil {
			log.Printf("Error: failed to get objects columns %q with clause %q and values %q: %v",
				columns, clause, values, err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(map[string]interface{}{
			"results": objs,
		})
		if err != nil {
			log.Printf("error returning object ID %q (%q): %v",
				clause, values, err)
		}
	}
}
