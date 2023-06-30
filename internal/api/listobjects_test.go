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

func TestListObjectsHandler(t *testing.T) {
	testCases := []struct {
		name             string
		path             string
		Fields           []string
		Clause           string
		Values           []interface{}
		expectedStatus   int
		expectedResponse string
	}{
		{"Get users with all fields works", "/api/user",
			[]string{"username", "role", "email", "google_id", "config"},
			"", []interface{}{},
			http.StatusOK, "testdata/list.json"},
		{"Get users with limited fields works", "/api/user",
			[]string{"username", "config"},
			"", []interface{}{},
			http.StatusOK, "testdata/list-limited-fields.json"},
		{"Get users with no fields works", "/api/user",
			[]string{},
			"", []interface{}{},
			http.StatusOK, "testdata/list-no-fields.json"},
		{"No matches gives empty list", "/api/user",
			[]string{"username", "role", "email", "google_id", "config"},
			"username = ?", []interface{}{"missing"},
			http.StatusOK, "testdata/empty-list.json"},
		{"Bad SQL gives 500", "/api/user",
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

			h := api.ListObjectsHandler(op)

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
