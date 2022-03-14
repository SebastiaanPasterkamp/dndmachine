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
		fields   []string
	}{
		{"GET anonymous denied", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
		},
			false,
			``,
			[]interface{}{},
			[]string{},
		},
		{"GET own character allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1), int64(2), int64(1)},
			[]string{"user_id", "name", "level", "progress", "config"},
		},
		{"GET list of character allowed", map[string]interface{}{
			"path":   []string{"api", "character"},
			"method": "GET",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`character.user_id = ? OR members.user_id = ?`,
			[]interface{}{int64(2), int64(2)},
			[]string{"user_id", "name", "level", "progress"},
		},
		{"GET some others character will not work", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:        6,
				Username:  "trudy",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(6), int64(1), int64(6), int64(1)},
			[]string{"user_id", "name", "level", "progress", "config"},
		},
		{"GET party character possible", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:        3,
				Username:  "bob",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?) OR (members.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(3), int64(1), int64(3), int64(1)},
			[]string{"user_id", "name", "level", "progress", "config"},
		},
		{"GET character as admin allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "GET",
			"user": &model.User{
				ID:        1,
				Username:  "admin",
				UserRoles: model.UserRoles{Role: []string{"admin"}},
			},
		},
			true,
			`character.id = ?`,
			[]interface{}{int64(1)},
			[]string{"user_id", "name", "level", "progress", "config"},
		},
		{"PATCH own character allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "PATCH",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1)},
			[]string{"name", "config"},
		},
		{"PATCH others character will not work", map[string]interface{}{
			"path":   []string{"api", "character", "2"},
			"method": "PATCH",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(2)},
			[]string{"name", "config"},
		},
		{"DELETE own character allowed", map[string]interface{}{
			"path":   []string{"api", "character", "1"},
			"method": "DELETE",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(1)},
			[]string{},
		},
		{"DELETE others character will not work", map[string]interface{}{
			"path":   []string{"api", "character", "2"},
			"method": "DELETE",
			"user": &model.User{
				ID:        2,
				Username:  "alice",
				UserRoles: model.UserRoles{Role: []string{"player"}},
			},
		},
			true,
			`(character.user_id = ? AND character.id = ?)`,
			[]interface{}{int64(2), int64(2)},
			[]string{},
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			possible, sql, err := p.Partial(ctx,
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

			if sql.Clause != tt.clause {
				t.Errorf("Unexpected clause. Expected %q, got %q.",
					tt.clause, sql.Clause)
			}

			if !reflect.DeepEqual(sql.Values, tt.values) {
				t.Errorf("Unexpected values. Expected %q, got %q.",
					tt.values, sql.Values)
			}

			if !reflect.DeepEqual(sql.Fields, tt.fields) {
				t.Errorf("Unexpected fields. Expected %q, got %q.",
					tt.fields, sql.Fields)
			}
		})
	}
}
