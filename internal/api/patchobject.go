package api

import (
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// PatchObjectHandler updates specific columns of a single object using the
// provided database.Operator using the columns, queries, and values provided by
// the IfPossible middleware.
func PatchObjectHandler(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

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
			log.Printf("Error: failed to get object columns %q to patch with clause %q and values %q: %v",
				columns, clause, values, err)
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)
			return
		}

		if j, ok := obj.(JSONable); ok {
			if err := j.UnmarshalFromReader(r.Body); err != nil {
				log.Printf("Error: failed to patch object %T: %v", j, err)
				return
			}
		} else {
			log.Printf("Error: object %T cannot be patched with JSON", obj)
			return
		}

		_, err = op.UpdateByQuery(r.Context(), db, obj, columns, clause, values...)
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

		w.WriteHeader(http.StatusNoContent)
	}
}
