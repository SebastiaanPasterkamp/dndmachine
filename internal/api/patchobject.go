package api

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

// PatchObjectHandler updates specific columns of a single object using the
// provided database.Operator using the columns, queries, and values provided by
// the IfPossible middleware.
func PatchObjectHandler(op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		ctx := r.Context()
		columns := ctx.Value(auth.SQLColumns).([]string)
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		obj, err := op.GetOneByQuery(ctx, columns, clause, values...)
		switch {
		case errors.Is(err, database.ErrNotFound):
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		case err != nil:
			log.Printf("Error: failed to get object columns %q to patch with clause %q and values %q: %v",
				columns, clause, values, err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		if j, ok := obj.(model.JSONable); ok {
			if err := j.UnmarshalFromReader(r.Body); err != nil {
				log.Printf("Error: failed to unmarshal payload %T: %v", j, err)
				http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
				return
			}
		} else {
			log.Printf("Error: object %T cannot be patched with JSON", obj)
			http.Error(w, http.StatusText(http.StatusNotImplemented), http.StatusNotImplemented)
			return
		}

		id, err := op.UpdateByQuery(r.Context(), obj, columns, clause, values...)
		switch {
		case errors.Is(err, database.ErrNotFound):
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		case err != nil:
			log.Printf("Error: failed to patch object for %q (%q): %v",
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
