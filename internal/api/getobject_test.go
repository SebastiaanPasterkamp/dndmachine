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
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func TestGetObjectHandler(t *testing.T) {
	testCases := []struct {
		name             string
		path             string
		Fields           []string
		Clause           string
		Values           []interface{}
		expectedStatus   int
		expectedResponse string
	}{
		{"Get admin with all fields works", "/api/user/1",
			[]string{"username", "role", "email", "google_id", "config"},
			"id = ?", []interface{}{1},
			http.StatusOK, "testdata/get.json"},
		{"Get admin with limited fields works", "/api/user/1",
			[]string{"username", "config"},
			"id = ?", []interface{}{1},
			http.StatusOK, "testdata/get-limited-fields.json"},
		{"Get admin with no fields works", "/api/user/1",
			[]string{},
			"id = ?", []interface{}{1},
			http.StatusOK, "testdata/get-no-fields.json"},
		{"Get unknown gives 404", "/api/user/99",
			[]string{"username", "role", "email", "google_id", "config"},
			"id = ?", []interface{}{99},
			http.StatusNotFound, ""},
		{"Bad SQL gives 500", "/api/user/1",
			[]string{"username", "role", "email", "google_id", "config"},
			"foo blah blah", []interface{}{},
			http.StatusInternalServerError, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("failed to create mock db: %v", err)
			}

			op := database.Operator{
				DB:    db,
				Table: "user",
				Create: func() model.Persistable {
					return &model.User{}
				},
				Read: func(r io.Reader) (model.Persistable, error) {
					p := model.User{}
					err := p.UnmarshalFromReader(r)
					return &p, err
				},
			}

			h := api.GetObjectHandler(op)

			w := httptest.NewRecorder()
			r := httptest.NewRequest("GET", tt.path, nil)

			ctx := r.Context()

			ctx = context.WithValue(ctx, auth.SQLColumns, tt.Fields)
			ctx = context.WithValue(ctx, auth.SQLClause, tt.Clause)
			ctx = context.WithValue(ctx, auth.SQLValues, tt.Values)

			r = r.WithContext(ctx)

			h(w, r)

			defer w.Result().Body.Close()

			if w.Result().StatusCode != tt.expectedStatus {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedStatus, w.Result().StatusCode)
			}

			if tt.expectedResponse != "" {
				response := w.Body.String()

				expected, err := os.ReadFile(tt.expectedResponse)
				if err != nil {
					t.Fatalf("failed to read expected response body: %v", err)
				}

				if response != string(expected) {
					t.Errorf("Unexpected response body. Expected %q %v, got %v.",
						tt.expectedResponse, string(expected), response)
				}
			}
		})
	}
}
