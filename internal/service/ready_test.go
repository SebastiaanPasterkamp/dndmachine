package service_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
)

func TestReady(t *testing.T) {
	t.Parallel()

	var testCases = []struct {
		name           string
		shutdown       bool
		expectedStatus int
		expectedClose  bool
	}{
		{"Running", false, http.StatusOK, false},
		{"Shutting down", true, http.StatusServiceUnavailable, true},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			ctx, cancel := context.WithCancel(context.Background())
			ack := make(chan interface{})
			h := service.HandleReady(ctx, ack)

			if tt.shutdown {
				cancel()
			} else {
				defer cancel()
			}

			w := httptest.NewRecorder()
			r := httptest.NewRequest("GET", "/ready", nil)

			h(w, r)

			if w.Result().StatusCode != tt.expectedStatus {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedStatus, w.Result().StatusCode)
			}

			select {
			case <-ack:
				if !tt.expectedClose {
					t.Error("Unexpected acknowledgement of shutdown.")
				}
			default:
				if tt.expectedClose {
					t.Error("Expected acknowledgement of shutdown.")
				}
			}
		})
	}
}
