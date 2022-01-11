package api

import (
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/go-chi/chi/v5"
)

func Mount(db database.Instance) http.Handler {
	r := chi.NewRouter()

	r.Route("/user", func(r chi.Router) {
		r.Route("/{objID:[0-9]+}", func(r chi.Router) {
			r.Get("/", GetObject(db, model.UserDB))
		})
	})

	return r
}
