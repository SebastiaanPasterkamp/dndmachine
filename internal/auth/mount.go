package auth

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/go-chi/chi/v5"
)

func Mount(db database.Instance, repo cache.Repository) http.Handler {
	r := chi.NewRouter()

	r.Post("/login", HandleLogin(db, repo))
	r.Get("/logout", HandleLogout(repo))
	r.With(WithSession(repo)).Get("/current-user", HandleCurrentUser())

	return r
}
