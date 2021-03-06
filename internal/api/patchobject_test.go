package api_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"os"
	"reflect"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/api"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func TestPatchObjectHandler(t *testing.T) {
	verifyColumns := []string{"username", "password", "role", "email", "google_id", "config"}

	testCases := []struct {
		name             string
		payload          string
		path             string
		Fields           []string
		Clause           string
		Values           []interface{}
		expectedStatus   int
		verifyID         int64
		expectedResponse string
	}{
		{"Patch user with all fields works", "testdata/patch.json", "/api/user/1",
			[]string{"username", "password", "role", "email", "google_id", "config"},
			"id = ?", []interface{}{1},
			http.StatusNoContent, 1, "testdata/patched.json"},
		{"Patch user with limited fields works", "testdata/patch.json", "/api/user/1",
			[]string{"config"},
			"id = ?", []interface{}{1},
			http.StatusNoContent, 1, "testdata/patched-limited-fields.json"},
		{"Bad payload gives 400", "/dev/null", "/api/user/1",
			[]string{"username", "role", "email", "google_id", "config"},
			"id = ?", []interface{}{1},
			http.StatusBadRequest, 0, ""},
		{"Patch unknown gives 404", "testdata/patch.json", "/api/user/99",
			[]string{"username", "role", "email", "google_id", "config"},
			"id = ?", []interface{}{99},
			http.StatusNotFound, 0, ""},
		{"Bad SQL gives 500", "testdata/patch.json", "/api/user/1",
			[]string{"username", "role", "email", "google_id", "config"},
			"foo blah blah", []interface{}{},
			http.StatusInternalServerError, 0, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("failed to create mock db: %v", err)
			}

			h := api.PatchObjectHandler(db, model.UserDB)

			payload, err := os.Open(tt.payload)
			if err != nil {
				t.Fatalf("failed to load payload: %v", err)
			}
			defer func() {
				_ = payload.Close()
			}()

			w := httptest.NewRecorder()
			r := httptest.NewRequest("PATCH", tt.path, payload)

			ctx := r.Context()

			ctx = context.WithValue(ctx, auth.SQLColumns, tt.Fields)
			ctx = context.WithValue(ctx, auth.SQLClause, tt.Clause)
			ctx = context.WithValue(ctx, auth.SQLValues, tt.Values)

			r = r.WithContext(ctx)

			h(w, r)

			if w.Result().StatusCode != tt.expectedStatus {
				t.Errorf("Unexpected status code. Expected %d, got %d.",
					tt.expectedStatus, w.Result().StatusCode)
			}

			if tt.verifyID > 0 {
				obj, err := model.UserDB.GetByID(ctx, db, verifyColumns, tt.verifyID)
				if err != nil {
					t.Fatalf("failed to retrieve verify object: %v", err)
				}

				user, ok := obj.(*model.User)
				if !ok {
					t.Fatalf("obj is not of type %T, but %T", user, obj)
				}

				input, err := os.Open(tt.expectedResponse)
				if err != nil {
					t.Fatalf("failed to open expected response: %v", err)
				}
				defer func() {
					_ = payload.Close()
				}()

				expected, err := model.UserFromReader(input)

				if user.Password == "" || len(user.Password) < 7 || user.Password[:7] != "$2a$10$" {
					t.Fatalf("failed to open expected response: %v", err)
				}
				user.Password = ""

				if !reflect.DeepEqual(expected, user) {
					t.Errorf("Unexpected object stored. Expected %T %v, got %T %v.",
						expected, expected, user, user)
				}
			}
		})
	}
}
