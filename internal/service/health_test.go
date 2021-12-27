package service_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
)

func TestHealth(t *testing.T) {
	t.Parallel()

	h := service.HandleHealth()

	w := httptest.NewRecorder()
	r := httptest.NewRequest("GET", "/health", nil)

	h(w, r)

	defer w.Result().Body.Close()

	if w.Result().StatusCode != http.StatusOK {
		t.Errorf("Unexpected status code. Expected %d, got %d.",
			http.StatusOK, w.Result().StatusCode)
	}
}
