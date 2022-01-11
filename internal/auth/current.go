package auth

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func HandleCurrentUser() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		user, ok := r.Context().Value(CurrentUser).(*model.User)
		if !ok {
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)

			return
		}

		w.Header().Set("Content-Type", "application/json")

		err := json.NewEncoder(w).Encode(user)
		if err != nil {
			log.Printf("writing version failed: %v", err)
		}
	}
}
