package service

import (
	"context"
	"fmt"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/api"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func (s *Instance) Router(ctx context.Context, db database.Instance) (*chi.Mux, error) {
	repo, err := cache.Factory(ctx, s.Configuration)
	if err != nil {
		return nil, fmt.Errorf("failed to initialize cache: %w", err)
	}

	opa, err := policy.NewEnforcer(policy.Configuration{})
	if err != nil {
		return nil, fmt.Errorf("failed to initialize policy: %w", err)
	}

	r := chi.NewRouter()

	// A good base middleware stack
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.Compress(5))

	// Set a timeout value on the request context (ctx), that will signal
	// through ctx.Done() that the request has timed out and further
	// processing should be stopped.
	r.Use(middleware.Timeout(s.RequestTimeout))

	s.shutdownAck = make(chan interface{})
	rdy, cancel := context.WithCancel(ctx)
	s.shutdownStart = &cancel

	r.Get("/ready", HandleReady(rdy, s.shutdownAck))
	r.Get("/health", HandleHealth())
	r.Get("/version", HandleVersion())

	if s.PublicPath != "" {
		fs := http.FileServer(http.Dir(s.PublicPath))
		r.Handle("/", http.FileServer(http.Dir(s.PublicPath)))
		r.Handle("/ui/*", http.StripPrefix("/ui/", fs))
	}

	r.Route("/auth", func(r chi.Router) {
		r.Mount("/", auth.Mount(db, repo))
	})

	r.Route("/api", func(r chi.Router) {
		r.Use(auth.WithSession(repo))
		r.Mount("/", api.Mount(db, opa))
	})

	return r, nil
}
