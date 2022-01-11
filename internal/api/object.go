package api

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/go-chi/chi/v5"
)

func GetObject(db database.Instance, op database.Operator) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		objID, err := strconv.Atoi(chi.URLParam(r, "objID"))
		if err != nil {
			http.Error(w, fmt.Sprintf("failed to parse object ID %q: %v", objID, err),
				http.StatusInternalServerError)
			return
		}

		obj, err := op.GetByID(r.Context(), db, objID)

		if errors.Is(err, database.ErrNotFound) {
			http.Error(w, http.StatusText(404), 404)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		err = json.NewEncoder(w).Encode(obj)
		if err != nil {
			log.Printf("error returning object ID %d: %v", objID, err)
		}
	}
}
