package service

import (
	"context"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func (s *Instance) Router(ctx context.Context, db database.Instance) *chi.Mux {
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

	return r
}
