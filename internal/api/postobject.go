package api

import (
	"fmt"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// PostObjectHandler inserts specific columns of a single object using the
// provided database.Operator using the columns, queries, and values provided by
// the IfPossible middleware.
func PostObjectHandler(db database.Instance, create NewPersistable, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		obj, err := create(r.Body)
		if err != nil {
			log.Printf("Error: failed to create object: %v", err)
			http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
			return
		}

		ctx := r.Context()
		columns := ctx.Value(auth.SQLColumns).([]string)
		clause := ctx.Value(auth.SQLClause).(string)
		values := ctx.Value(auth.SQLValues).([]interface{})

		id, err := op.InsertByQuery(ctx, db, obj, columns, clause, values...)
		if err != nil {
			log.Printf("Error: failed to insert object for %q (%q): %v",
				clause, values, err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		newURL := fmt.Sprintf("%s/%d", r.RequestURI, id)

		http.Redirect(w, r, newURL, http.StatusTemporaryRedirect)
	}
}
