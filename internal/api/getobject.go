package api

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func GetObjectHandler(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		clause := ctx.Value(policy.Clause).(string)
		values := ctx.Value(policy.Values).([]interface{})

		obj, err := op.GetOneByQuery(r.Context(), db, clause, values...)
		switch {
		case errors.Is(err, database.ErrNotFound):
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		case err != nil:
			log.Printf("Error: failed to get object(s) for %q (%q): %v",
				clause, values, err)
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