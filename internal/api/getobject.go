package api

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// GetObjectHandler returns a single object from the provided database.Operator
// using the columns, queries, and values provided by the IfPossible middleware.
func GetObjectHandler(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		columns := ctx.Value(auth.SQLColumns).([]string)
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		obj, err := op.GetOneByQuery(ctx, db, columns, clause, values...)
		switch {
		case errors.Is(err, database.ErrNotFound):
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		case err != nil:
			log.Printf("Error: failed to get object columns %q with clause %q and values %q: %v",
				columns, clause, values, err)
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(map[string]interface{}{
			"result": obj,
		})
		if err != nil {
			log.Printf("error returning object ID %q (%q): %v",
				clause, values, err)
		}
	}
}
