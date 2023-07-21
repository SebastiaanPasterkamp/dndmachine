package api

import (
	"io"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model/character/options"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
)

// Mount returns a chi.Router with all supported CRUD end-points.
func Mount(db database.Instance, e *policy.Enforcer) http.Handler {
	r := chi.NewRouter()

	r.Route("/user", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.user.allow", []string{"user"}))

		op := database.Operator{
			DB:    db,
			Table: "user",
			Create: func() model.Persistable {
				return &model.User{}
			},
			Read: func(r io.Reader) (model.Persistable, error) {
				p := model.User{}
				err := p.UnmarshalFromReader(r)
				return &p, err
			},
		}

		r.Get("/", ListObjectsHandler(op))
		r.Post("/", PostObjectHandler(op))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(op))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(op))
	})

	r.Route("/character", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.character.allow", []string{"character"}))

		op := database.Operator{
			DB:    db,
			Table: "character",
			SelectJoin: []string{
				"LEFT JOIN party_characters AS party1 ON (character.id=party1.character_id)",
				"LEFT JOIN party_characters AS party2 ON (party2.party_id=party1.party_id and party2.character_id!=character.id)",
				"LEFT JOIN character AS member ON (member.id=party2.character_id)",
			},
			Create: func() model.Persistable {
				return &character.Object{}
			},
			Read: func(r io.Reader) (model.Persistable, error) {
				p := character.Object{}
				err := p.UnmarshalFromReader(r)
				return &p, err
			},
		}

		r.Get("/", ListObjectsHandler(op))
		r.Post("/", PostObjectHandler(op))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(op))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(op))
	})

	r.Route("/character-option", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.character_option.allow", []string{"character_option"}))

		op := database.Operator{
			DB:    db,
			Table: "character_option",
			Create: func() model.Persistable {
				return &options.Object{}
			},
			Read: func(r io.Reader) (model.Persistable, error) {
				p := options.Object{}
				err := p.UnmarshalFromReader(r)
				return &p, err
			},
		}

		r.Get("/", ListObjectsHandler(op))
		r.Post("/", PostObjectHandler(op))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(op))
		r.Get("/uuid/{UUIID:[0-9a-f-]+}", GetObjectHandler(op))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(op))
	})

	r.Route("/equipment", func(r chi.Router) {
		r.Use(auth.IfPossible(e, "authz.equipment.allow", []string{"equipment"}))

		op := database.Operator{
			DB:    db,
			Table: "equipment",
			Create: func() model.Persistable {
				return &model.Equipment{}
			},
			Read: func(r io.Reader) (model.Persistable, error) {
				p := model.Equipment{}
				err := p.UnmarshalFromReader(r)
				return &p, err
			},
		}

		r.Get("/", ListObjectsHandler(op))
		r.Post("/", PostObjectHandler(op))
		r.Get("/{objID:[0-9]+}", GetObjectHandler(op))
		r.Patch("/{objID:[0-9]+}", PatchObjectHandler(op))
	})

	return r
}
