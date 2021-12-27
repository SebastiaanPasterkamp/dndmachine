package service_test

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
)

func TestRouter(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name           string
		verb           string
		path           string
		reader         io.Reader
		expectedStatus int
	}{
		{"Working GET /health", "GET", "/health", nil,
			http.StatusOK},
		{"Rejected POST /health", "POST", "/health", nil,
			http.StatusMethodNotAllowed},
		{"Working GET /ready", "GET", "/ready", nil,
			http.StatusOK},
		{"Rejected POST /ready", "POST", "/ready", nil,
			http.StatusMethodNotAllowed},
		{"Working GET /version", "GET", "/version", nil,
			http.StatusOK},
		{"Rejected PATCH /version", "PATCH", "/version", nil,
			http.StatusMethodNotAllowed},
		{"Rejected GET /unknown", "GET", "/unknown", nil,
			http.StatusNotFound},
		{"Cancel slow GET /read", "GET", "/read", slowReader{Delay: time.Second},
			http.StatusRequestTimeout},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			ctx := context.Background()

			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("Failed to create mock DB: %v", err)
			}

			s := service.Instance{
				RequestTimeout: 500 * time.Microsecond,
				ReadTimeout:    500 * time.Microsecond,
			}

			h := s.Router(ctx, db)
			h.Get("/read", func(w http.ResponseWriter, r *http.Request) {
				b := []byte{}
				c := make(chan error, 1)

				go func(b []byte) {
					_, err := r.Body.Read(b)
					c <- err
					close(c)
				}(b)

				select {
				case err := <-c:
					t.Errorf("Unexpected error in /read: %v", err)
					w.WriteHeader(http.StatusExpectationFailed)
				case <-r.Context().Done():
					w.WriteHeader(http.StatusRequestTimeout)
				}
			})

			w := httptest.NewRecorder()
			r := httptest.NewRequest(tt.verb, tt.path, tt.reader)

			h.ServeHTTP(w, r)

			if w.Result().StatusCode != tt.expectedStatus {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedStatus, w.Result().StatusCode)
			}
		})
	}
}

type slowReader struct {
	Delay time.Duration
}

func (s slowReader) Read(_ []byte) (int, error) {
	time.Sleep(s.Delay)
	return 0, io.EOF
}
