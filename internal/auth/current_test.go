package auth_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func TestHandleCurrentUser(t *testing.T) {
	t.Parallel()

	current := auth.HandleCurrentUser()

	testCases := []struct {
		name             string
		user             *model.User
		expectedCode     int
		expectedResponse string
	}{
		{"No current user yields 404x", nil,
			http.StatusNotFound, "Not Found\n"},
		{"Active session gives user", &model.User{ID: 1, Username: "user", Password: "hide me", UserRoles: model.UserRoles{Role: []string{"player"}}},
			http.StatusOK, "{\"role\":[\"player\"],\"id\":1,\"username\":\"user\"}\n"},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			w := httptest.NewRecorder()
			r := httptest.NewRequest("GET", "/auth/current", nil)

			if tt.user != nil {
				ctx := context.WithValue(r.Context(), auth.CurrentUser, tt.user)
				r = r.WithContext(ctx)
			}

			current.ServeHTTP(w, r)

			if w.Result().StatusCode != tt.expectedCode {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedCode, w.Result().StatusCode)
			}

			if w.Body.String() != tt.expectedResponse {
				t.Errorf("Unexpected response body. Expected %q, got %q.",
					tt.expectedResponse, w.Body.String())
			}
		})
	}
}
