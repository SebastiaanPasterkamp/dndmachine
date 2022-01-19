package policy_test

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

	authz := policy.IfPossible(e, "authz.character.allow", []string{"character"})

	testCases := []struct {
		name         string
		path         string
		user         *model.User
		expectedCode int
		clause       string
		values       []interface{}
	}{
		{"GET anonymous denied", "/api/character/1", nil,
			http.StatusUnauthorized,
			``,
			[]interface{}{},
		},
		{"GET own character allowed", "/api/character/1", &model.User{ID: 2},
			http.StatusOK,
			`(members.user_id = ? AND character.id = ?) OR (character.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1), int64(2), int64(1)},
		},
		{"GET character as admin allowed", "/api/character/1", &model.User{ID: 1, UserAttributes: model.UserAttributes{Role: []string{"admin"}}},
			http.StatusOK,
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
				clause := ctx.Value(policy.Clause).(string)
				values := ctx.Value(policy.Values).([]interface{})

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
