package api

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
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

		r.Get("/", ListObjectsHandler(db, model.CharacterDB))
		r.Post("/", PostObjectHandler(db, model.CharacterFromReader, model.CharacterDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.CharacterDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.CharacterDB))
	})

	r.Route("/equipment", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.equipment.allow", []string{"equipment"}))

		r.Get("/", ListObjectsHandler(db, model.EquipmentDB))
		r.Post("/", PostObjectHandler(db, model.EquipmentFromReader, model.EquipmentDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.EquipmentDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.EquipmentDB))
	})

	r.Route("/race", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.race.allow", []string{"race"}))

		r.Get("/", ListObjectsHandler(db, model.RaceDB))
		r.Post("/", PostObjectHandler(db, model.CharacteristicFromReader, model.RaceDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.RaceDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.RaceDB))
	})

	r.Route("/class", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.class.allow", []string{"class"}))

		r.Get("/", ListObjectsHandler(db, model.ClassDB))
		r.Post("/", PostObjectHandler(db, model.CharacteristicFromReader, model.ClassDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.ClassDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.ClassDB))
	})

	r.Route("/background", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.background.allow", []string{"background"}))

		r.Get("/", ListObjectsHandler(db, model.BackgroundDB))
		r.Post("/", PostObjectHandler(db, model.CharacteristicFromReader, model.BackgroundDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.BackgroundDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.BackgroundDB))
	})

	r.Route("/characteristic", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.characteristic_option.allow", []string{"characteristic_option"}))

		r.Get("/", ListObjectsHandler(db, model.CharacteristicOptionDB))
		r.Post("/", PostObjectHandler(db, model.CharacteristicOptionFromReader, model.CharacteristicOptionDB))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(db, model.CharacteristicOptionDB))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(db, model.CharacteristicOptionDB))
	})

	return r
}
