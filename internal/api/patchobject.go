package api

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func PatchObjectHandler(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		ctx := r.Context()
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		obj, err := op.UpdateByQuery(r.Context(), db, r.Body, clause, values...)
		switch {
		case errors.Is(err, database.ErrNotFound):
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		case err != nil:
			log.Printf("Error: failed to patch object for %q (%q): %v",
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
