package auth_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/auth"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func TestIfPossible(t *testing.T) {
	t.Parallel()

	e, err := policy.NewEnforcer(policy.Configuration{})
	if err != nil {
		t.Fatalf("Failed to initialize policy enforcer: %v", err)
	}

	authz := auth.IfPossible(e, "authz.character.allow", []string{"character"})

	testCases := []struct {
		name         string
		path         string
		user         *model.User
		expectedCode int
		columns      []string
		clause       string
		values       []interface{}
	}{
		{"GET anonymous denied", "/api/character/1", nil,
			http.StatusUnauthorized,
			[]string{},
			``,
			[]interface{}{},
		},
		{"GET own character allowed", "/api/character/1", &model.User{ID: 2, UserRoles: model.UserRoles{Role: []string{"player"}}},
			http.StatusOK,
			[]string{"user_id", "name", "level", "config", "result"},
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1), int64(2), int64(1)},
		},
		{"GET character as admin allowed", "/api/character/1", &model.User{ID: 1, UserRoles: model.UserRoles{Role: []string{"admin"}}},
			http.StatusOK,
			[]string{"user_id", "name", "level", "config", "result"},
			`character.id = ?`,
			[]interface{}{int64(1)},
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			next := authz(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				ctx := r.Context()
				columns := ctx.Value(auth.SQLColumns).([]string)
				clause := ctx.Value(auth.SQLClause).(string)
				values := ctx.Value(auth.SQLValues).([]interface{})

				if !reflect.DeepEqual(columns, tt.columns) {
					t.Errorf("Unexpected columns. Expected %q, got %q.",
						tt.columns, columns)
				}

				if clause != tt.clause {
					t.Errorf("Unexpected clause. Expected %q, got %q.",
						tt.clause, clause)
				}

				if !reflect.DeepEqual(values, tt.values) {
					t.Errorf("Unexpected values. Expected %q, got %q.",
						tt.values, values)
				}

				w.WriteHeader(http.StatusOK)
			}))

			w := httptest.NewRecorder()
			r := httptest.NewRequest("GET", tt.path, nil)

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
