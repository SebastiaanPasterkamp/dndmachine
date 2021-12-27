package service

import (
	"context"
	"errors"
	"fmt"
	"net"
	"net/http"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func (s *Instance) Launch(ctx context.Context, db database.Instance) error {
	listener, err := net.Listen("tcp", ":"+s.Port)
	if err != nil {
		return fmt.Errorf("error launching server: %w", err)
	}

	s.mu.Lock()
	s.url = "http://" + listener.Addr().String()
	s.srv = &http.Server{
		Handler:           s.Router(ctx, db),
		ReadTimeout:       s.ReadTimeout,
		ReadHeaderTimeout: s.ReadHeaderTimeout,
		WriteTimeout:      s.WriteTimeout,
		IdleTimeout:       s.IdleTimetout,
	}
	s.mu.Unlock()

	err = s.srv.Serve(listener)
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("error launching server: %w", err)
	}

	return nil
}

func (s *Instance) URL() string {
	s.mu.Lock()
	defer s.mu.Unlock()

	return s.url
}

func (s *Instance) Shutdown(ctx context.Context) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.srv == nil {
		return nil
	}

	if s.shutdownStart != nil {
		(*s.shutdownStart)()
	}

	var wasForced error

	if s.MaxShutdownDelay > 0*time.Second {
		delay := time.After(s.MaxShutdownDelay)
		select {
		case <-delay:
			wasForced = ErrForcedShutdown
		case <-s.shutdownAck:
		}
	}

	dl := ctx

	if s.ShutdownDeadline > 0*time.Second {
		var cancel context.CancelFunc
		dl, cancel = context.WithTimeout(ctx, s.ShutdownDeadline)

		defer cancel()
	}

	err := s.srv.Shutdown(dl)
	if err != nil {
		return fmt.Errorf("error shutting down server: %w", err)
	}

	s.srv = nil

	if wasForced != nil {
		return wasForced
	}

	return nil
}
