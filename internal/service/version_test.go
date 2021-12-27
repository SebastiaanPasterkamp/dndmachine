package service_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
)

func TestVersion(t *testing.T) {
	t.Parallel()

	h := service.HandleVersion()

	w := httptest.NewRecorder()
	r := httptest.NewRequest("GET", "/health", nil)

	h(w, r)

	if w.Result().StatusCode != http.StatusOK {
		t.Errorf("Unexpected status code. Expected %d, got %d.",
			http.StatusOK, w.Result().StatusCode)
	}

	expectedBody := `{"name":"D\u0026D Machine","version":"unknown","commit":"unknown","branch":"unknown","timestamp":"unknown"}`
	if w.Body.String() != expectedBody {
		t.Errorf("Unexpected response body. Expected %v, got %v.",
			expectedBody, w.Body.String())
	}

	expectedCT := `application/json`
	if w.Header().Get("content-type") != expectedCT {
		t.Errorf("Unexpected content type. Expected %v, got %v.",
			expectedCT, w.Header().Get("content-type"))
	}
}
