package service_test

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
	"golang.org/x/sync/errgroup"
)

func TestLaunchAndShutdown(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name          string
		delay         time.Duration
		firstProbe    string
		secondProbe   string
		firstStatus   int
		secondStatus  int
		expectedError string
	}{
		{"Fast shutdown without delay", 0 * time.Second, "/version", "/version",
			http.StatusOK, 0, "dial tcp"},
		{"Fast shutdown after /ready probe", 1 * time.Second, "/ready", "/ready",
			http.StatusOK, http.StatusServiceUnavailable, ""},
		{"Forced shutdown after deadline", 1 * time.Second, "/version", "/version",
			http.StatusOK, http.StatusOK, "shutdown forced"},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {

			ctx := context.Background()

			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("Failed to create mock DB: %v", err)
			}

			s := service.Instance{
				MaxShutdownDelay: tt.delay,
				ShutdownDeadline: 500 * time.Millisecond,
			}

			g, gCTx := errgroup.WithContext(ctx)

			g.Go(func() error {
				return s.Launch(gCTx, db)
			})

			time.Sleep(100 * time.Millisecond)

			URL := s.URL()

			res, err := http.Get(URL + tt.firstProbe)
			if err != nil {
				t.Fatalf("Unexpected error calling %q: %v", tt.firstProbe, err)
			}
			defer res.Body.Close()

			if res.StatusCode != tt.firstStatus {
				t.Errorf("Unexpected status code from %q. Expected %d, got %d.",
					tt.firstProbe, tt.firstStatus, res.StatusCode)
			}

			g.Go(func() error {
				return s.Shutdown(gCTx)
			})

			time.Sleep(100 * time.Millisecond)

			g.Go(func() error {
				res, err := http.Get(URL + tt.secondProbe)
				if err != nil {
					return fmt.Errorf("unexpected error calling %q: %v", tt.secondProbe, err)
				}

				if res.StatusCode != tt.secondStatus {
					t.Errorf("Unexpected status code from %q. Expected %d, got %d.",
						tt.secondProbe, tt.secondStatus, res.StatusCode)
				}

				return nil
			})

			err = g.Wait()
			if err != nil && !strings.Contains(err.Error(), tt.expectedError) {
				t.Errorf("Unexpected error. Expected %v, got %v.",
					tt.expectedError, err)
			}

			if err == nil && tt.expectedError != "" {
				t.Errorf("Expected error. Expected %v, got %v.",
					tt.expectedError, err)
			}
		})
	}
}
