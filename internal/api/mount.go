package api

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
)

// Mount returns a chi.Router with all supported CRUD end-points.
func Mount(db database.Instance, e *policy.Enforcer) http.Handler {
	r := chi.NewRouter()

	r.Route("/user", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.user.allow", []string{"user"}))

		r.Get("/", ListObjectsHandler(db, model.UserDB))
		r.Post("/", PostObjectHandler(db, model.UserFromReader, model.UserDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.UserDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.UserDB))
	})

	r.Route("/character", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.character.allow", []string{"character"}))

		r.Get("/", ListObjectsHandler(db, character.DB))
		r.Post("/", PostObjectHandler(db, character.FromReader, character.DB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, character.DB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, character.DB))
	})

	r.Route("/equipment", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.equipment.allow", []string{"equipment"}))

		r.Get("/", ListObjectsHandler(db, model.EquipmentDB))
		r.Post("/", PostObjectHandler(db, model.EquipmentFromReader, model.EquipmentDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.EquipmentDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.EquipmentDB))
	})

	return r
}
