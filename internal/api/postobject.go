package api

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func PostObjectHandler(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		ctx := r.Context()
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		obj, err := op.InsertByQuery(ctx, db, r.Body, clause, values...)
		if err != nil {
			log.Printf("Error: failed to insert object for %q (%q): %v",
				clause, values, err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(map[string]interface{}{
			"result": obj,
		})
		if err != nil {
			log.Printf("error returning new object %q (%q): %v",
				clause, values, err)
		}
	}
}
