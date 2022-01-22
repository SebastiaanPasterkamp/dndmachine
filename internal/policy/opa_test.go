package policy_test

import (
	"context"
	"reflect"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/policy"
)

func TestAllowed(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	p, err := policy.NewEnforcer(policy.Configuration{
		Path: "testdata",
	})
	if err != nil {
		t.Fatalf("Failed to initiate policy enforcer: %v", err)
	}

	testCases := []struct {
		name     string
		input    map[string]interface{}
		expected bool
	}{
		{"GET anonymous denied", map[string]interface{}{
			"path":   []interface{}{"user", 2},
			"method": "GET",
		},
			false},
		{"GET own user allowed", map[string]interface{}{
			"path":   []interface{}{"user", 2},
			"method": "GET",
			"user":   map[string]interface{}{"id": 2},
		},
			true},
		{"GET another user denied", map[string]interface{}{
			"path":   []interface{}{"user", 2},
			"method": "GET",
			"user":   map[string]interface{}{"id": 3},
		},
			false},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			allowed, err := p.Allow(ctx, "testing.allow", tt.input)
			if err != nil {
				t.Errorf("Unexpected error: %v", err)
			}

			if allowed != tt.expected {
				t.Errorf("Unexpected result. Expected %v, got %v.",
					tt.expected, allowed)
			}
		})
	}
}

func TestPartial(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	p, err := policy.NewEnforcer(policy.Configuration{})
	if err != nil {
		t.Fatalf("Failed to initiate policy enforcer: %v", err)
	}

	testCases := []struct {
		name     string
		input    map[string]interface{}
		expected bool
		clause   string
		values   []interface{}
	}{
		{"GET anonymous denied", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
		},
			false,
			``,
			[]interface{}{},
		},
		{"GET own character allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:       2,
				Username: "alice",
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1), int64(2), int64(1)},
		},
		{"GET some others character denied", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:       6,
				Username: "trudy",
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(6), int64(1), int64(6), int64(1)},
		},
		{"GET party character possible", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:       3,
				Username: "bob",
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(3), int64(1), int64(3), int64(1)},
		},
		{"GET character as admin allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:       1,
				Username: "admin",
				UserAttributes: model.UserAttributes{
					Role: []string{"admin"},
				},
			},
		},
			true,
			`character.id = ?`,
			[]interface{}{int64(1)},
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			possible, clause, values, err := p.Partial(ctx,
				"authz.character.allow",
				[]string{"character"},
				tt.input,
			)
			if err != nil {
				t.Errorf("Unexpected error: %v", err)
			}

			if possible != tt.expected {
				t.Errorf("Unexpected result. Expected %v, got %v.",
					tt.expected, possible)
			}

			if clause != tt.clause {
				t.Errorf("Unexpected clause. Expected %q, got %q.",
					tt.clause, clause)
			}

			if !reflect.DeepEqual(values, tt.values) {
				t.Errorf("Unexpected values. Expected %q, got %q.",
					tt.values, values)
			}
		})
	}
}
