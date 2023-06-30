package api

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// PostObjectHandler inserts specific columns of a single object using the
// provided database.Operator using the columns, queries, and values provided by
// the IfPossible middleware.
func PostObjectHandler(op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		obj, err := op.Read(r.Body)
		if err != nil {
			log.Printf("Error: failed to create object: %v", err)
			http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
			return
		}

		ctx := r.Context()
		columns := ctx.Value(auth.SQLColumns).([]string)
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		id, err := op.InsertByQuery(ctx, obj, columns, clause, values...)
		if err != nil {
			log.Printf("Error: failed to insert object for %q (%q): %v",
				clause, values, err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(map[string]interface{}{
			"result": map[string]int64{
				"id": id,
			},
		})
		if err != nil {
			log.Printf("error returning object ID %d: %v", id, err)
		}
	}
}
