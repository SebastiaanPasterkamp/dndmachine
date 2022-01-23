package auth

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
)

func Mount(db database.Instance, e *policy.Enforcer, repo cache.Repository) http.Handler {
	r := chi.NewRouter()
	r.Use(IfAllowed(e, "authz.auth.allow"))

	r.Post("/login", HandleLogin(db, repo))
	r.Get("/logout", HandleLogout(repo))
	r.Get("/current-user", HandleCurrentUser())

	return r
}
