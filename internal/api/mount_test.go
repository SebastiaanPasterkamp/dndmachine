package api_test

import (
	"context"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/api"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
	"github.com/go-chi/chi/v5"
)

func TestMount(t *testing.T) {
	opa, err := policy.NewEnforcer(policy.Configuration{})
	if err != nil {
		t.Fatalf("failed to initialize policy: %v", err)
	}

	testCases := []struct {
		name             string
		method           string
		path             string
		input            string
		user             *model.User
		expectedStatus   int
		expectedResponse string
	}{
		{"Get user as user works", "GET", "/api/user/1", "",
			&model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusOK, "testdata/get.json"},
		{"Get user as anonymous is denied", "GET", "/api/user/1", "",
			nil,
			http.StatusUnauthorized, ""},
		{"Get user as other gives 404", "GET", "/api/user/1", "",
			&model.User{ID: 2},
			http.StatusNotFound, ""},
		{"List users as admin works", "GET", "/api/user", "",
			&model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusOK, "testdata/list.json"},
		{"List users as non-admin extremely limited", "GET", "/api/user", "",
			&model.User{ID: 2, UserRoles: model.UserRoles{Role: []string{"dm"}}},
			http.StatusOK, "testdata/list-empty.json"},
		{"Get unknown gives 404", "GET", "/api/foobar", "",
			&model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusNotFound, ""},
		{"Post user as admin works", "POST", "/api/user", "testdata/post.json",
			&model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusOK, ""},
		{"Post user as non-admin denied", "POST", "/api/user", "testdata/post.json",
			&model.User{ID: 2, UserRoles: model.UserRoles{Role: []string{"dm"}}},
			http.StatusUnauthorized, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("failed to create mock db: %v", err)
			}

			mux := chi.NewRouter()
			mux.Route("/api", func(r chi.Router) {
				r.Mount("/", api.Mount(db, opa))
			})

			var src io.Reader
			if tt.input != "" {
				src, err = os.Open(tt.input)
				if err != nil {
					t.Fatalf("failed to open input file %q: %v", tt.input, err)
				}
			}

			w := httptest.NewRecorder()
			r := httptest.NewRequest(tt.method, tt.path, src)

			ctx := r.Context()
			ctx = context.WithValue(ctx, auth.CurrentUser, tt.user)
			r = r.WithContext(ctx)

			mux.ServeHTTP(w, r)

			defer w.Result().Body.Close()

			if w.Result().StatusCode != tt.expectedStatus {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedStatus, w.Result().StatusCode)
			}

			if tt.expectedResponse == "" {
				return
			}

			response := w.Body.String()

			expected, err := os.ReadFile(tt.expectedResponse)
			if err != nil {
				t.Fatalf("failed to read expected response body: %v", err)
			}

			if response != string(expected) {
				t.Errorf("Unexpected response body. Expected %q %v, got %v.",
					tt.expectedResponse, string(expected), response)
			}
		})
	}
}
