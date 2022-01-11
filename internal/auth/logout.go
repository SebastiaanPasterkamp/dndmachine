package auth

import (
	"errors"
	"log"
	"net/http"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
)

func HandleLogout(repo cache.Repository) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sessionID, err := r.Cookie(SessionCookie)

		switch {
		case errors.Is(err, http.ErrNoCookie):
			w.WriteHeader(http.StatusOK)

			return
		case err != nil:
			log.Printf("failed to get cookie: %v", err)
			http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)

			return
		}

		err = repo.Del(r.Context(), sessionID)
		if err != nil {
			log.Printf("failed to destroy session: %v", err)
		}

		http.SetCookie(w, logoutCookie())

		w.WriteHeader(http.StatusOK)
	}
}

func logoutCookie() *http.Cookie {
	return &http.Cookie{
		Name:    SessionCookie,
		Value:   "",
		Path:    "/",
		Expires: time.Now(),
		MaxAge:  0,
	}
}
