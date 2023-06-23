package auth

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

// HandleCurrentUser returns the user as stored in the context. Basically it
// returns the user associated with the active session.
func HandleCurrentUser() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		user, ok := r.Context().Value(CurrentUser).(*model.User)
		if !ok {
			http.Error(w, http.StatusText(http.StatusNotFound), http.StatusNotFound)

			return
		}

		// Don't need to include this in the output
		user.Password = ""

		w.Header().Set("Content-Type", "application/json")

		err := json.NewEncoder(w).Encode(user)
		if err != nil {
			log.Printf("writing current user failed: %v", err)
		}
	}
}
