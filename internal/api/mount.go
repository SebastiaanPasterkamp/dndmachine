package api

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
)

func Mount(db database.Instance, e *policy.Enforcer) http.Handler {
	r := chi.NewRouter()

	r.Route("/user", func(r chi.Router) {
		r.Use(policy.IfPossible(e, "authz.user.allow", []string{"user"}))

		r.Get("/", ListObjectsHandler(db, model.UserDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.UserDB))
	})

	r.Route("/character", func(r chi.Router) {
		r.Use(policy.IfPossible(e, "authz.character.allow", []string{"character"}))

		r.Get("/", ListObjectsHandler(db, model.CharacterDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.CharacterDB))
	})

	return r
}
