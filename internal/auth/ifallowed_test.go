package auth_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func TestIfAllowed(t *testing.T) {
	t.Parallel()

	e, err := policy.NewEnforcer(policy.Configuration{})
	if err != nil {
		t.Fatalf("Failed to initialize policy enforcer: %v", err)
	}

	authz := auth.IfAllowed(e, "authz.auth.allow")

	testCases := []struct {
		name         string
		method       string
		path         string
		user         *model.User
		expectedCode int
	}{
		{"GET login denied", "GET", "/auth/login", nil,
			http.StatusUnauthorized},
		{"POST login allowed", "POST", "/auth/login", nil,
			http.StatusOK},
		{"GET logout allowed", "GET", "/auth/logout", &model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusOK},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			next := authz(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.WriteHeader(http.StatusOK)
			}))

			w := httptest.NewRecorder()
			r := httptest.NewRequest(tt.method, tt.path, nil)

			ctx := context.WithValue(r.Context(), auth.CurrentUser, tt.user)
			r = r.WithContext(ctx)

			next.ServeHTTP(w, r)

			if w.Result().StatusCode != tt.expectedCode {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedCode, w.Result().StatusCode)
			}
		})
	}
}
