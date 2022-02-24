package auth

import (
	"context"
	"errors"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/google/uuid"
)

func WithSession(repo cache.Repository, required bool) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			cookie, err := r.Cookie(SessionCookie)
			switch {
			case errors.Is(err, http.ErrNoCookie):
				if !required {
					next.ServeHTTP(w, r)
				} else {
					http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				}
				return
			case err != nil:
				log.Printf("failed to get cookie: %v", err)
				http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
				return
			}

			sessionID, err := uuid.Parse(cookie.Value)
			if err != nil {
				log.Printf("invalid session ID: %v", err)
				http.SetCookie(w, logoutCookie())
				http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
				return
			}

			user := model.User{}

			err = repo.Get(r.Context(), sessionID.String(), &user)
			switch {
			case errors.Is(err, cache.ErrNotFound):
				log.Printf("invalid session %q: %v", sessionID, err)
				http.SetCookie(w, logoutCookie())
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			case err != nil:
				log.Printf("failed to load session %q: %v", sessionID, err)
				http.SetCookie(w, logoutCookie())
				http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
				return
			}

			http.SetCookie(w, loginCookie(cookie.Value))

			ctx := context.WithValue(r.Context(), CurrentUser, &user)
			r = r.WithContext(ctx)

			next.ServeHTTP(w, r)
		})
	}
}
