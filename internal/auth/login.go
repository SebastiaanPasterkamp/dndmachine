package auth

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

func HandleLogin(db database.Instance, repo cache.Repository) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var creds credentials
		if err := json.NewDecoder(r.Body).Decode(&creds); err != nil {
			log.Printf("failed to get credentials: %v", err)
			http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)

			return
		}

		obj, err := model.UserDB.GetByQuery(r.Context(), db, "username = ?", creds.Username)
		if errors.Is(err, database.ErrNotFound) {
			http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)

			return
		}

		user := obj.(model.User)

		err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(creds.Password))

		switch {
		case errors.Is(err, bcrypt.ErrMismatchedHashAndPassword):
			http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)

			return
		case err != nil:
			log.Printf("failed to verify credentials: %v", err)
			http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)

			return
		}

		sessionID := uuid.New().String()

		err = repo.Set(r.Context(), sessionID, user, 0)
		if err != nil {
			log.Printf("failed to initialize session: %v", err)
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)

			return
		}

		http.SetCookie(w, loginCookie(sessionID))

		w.Header().Set("Content-Type", "application/json")

		err = json.NewEncoder(w).Encode(user)
		if err != nil {
			log.Printf("writing user failed: %v", err)
		}
	}
}

func loginCookie(sessionID string) *http.Cookie {
	return &http.Cookie{
		Name:    SessionCookie,
		Value:   sessionID,
		Path:    "/",
		Expires: time.Now().Add(time.Hour),
	}
}
