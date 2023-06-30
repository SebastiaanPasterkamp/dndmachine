package database_test

import (
	"context"
	"errors"
	"reflect"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func TestGetByID(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	db, err := mockDatabase()
	if err != nil {
		t.Fatalf("Failed to get DB: %v", err)
	}

	op := mockOperator(db)

	testCases := []struct {
		name     string
		id       int64
		columns  []string
		err      error
		expected *Mock
	}{
		{"get all", 1, []string{"name", "config"},
			nil, &Mock{ID: 1, Name: "test", MockAttributes: MockAttributes{Something: "else"}}},
		{"only get name", 1, []string{"name"},
			nil, &Mock{ID: 1, Name: "test", MockAttributes: MockAttributes{}}},
		{"only get config", 1, []string{"config"},
			nil, &Mock{ID: 1, MockAttributes: MockAttributes{Something: "else"}}},
		{"get unknown fails", 999, []string{"name"},
			database.ErrNotFound, nil},
		{"get unknown column fails", 1, []string{"name", "foo", "bar"},
			database.ErrQueryFailed, nil},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			p, err := op.GetByID(ctx, tt.columns, tt.id)
			if !errors.Is(err, tt.err) {
				t.Errorf("Unexpected error. Expected %v, got %v.", tt.err, err)
			}

			if tt.err != nil {
				if p != nil {
					t.Errorf("Unexpected return value. Expected %v, got %v instead.",
						tt.expected, p)
				}
				return
			}

			if !reflect.DeepEqual(p, tt.expected) {
				t.Errorf("Unexpected *Mock{}. Expected %q, got %q.", tt.expected, p)
			}
		})
	}
}

func TestGetByQuery(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	db, err := mockDatabase()
	if err != nil {
		t.Fatalf("Failed to get DB: %v", err)
	}

	op := mockOperator(db)

	testCases := []struct {
		name     string
		clause   string
		values   []interface{}
		columns  []string
		err      error
		expected []*Mock
	}{
		{"get all", "id = ?", []interface{}{1}, []string{"name", "config"},
			nil, []*Mock{{ID: 1, Name: "test", MockAttributes: MockAttributes{Something: "else"}}}},
		{"only get name", "id = ?", []interface{}{1}, []string{"name"},
			nil, []*Mock{{ID: 1, Name: "test", MockAttributes: MockAttributes{}}}},
		{"only get config", "id = ?", []interface{}{1}, []string{"config"},
			nil, []*Mock{{ID: 1, MockAttributes: MockAttributes{Something: "else"}}}},
		{"get unknown fails", "id = ?", []interface{}{2}, []string{"name"},
			nil, []*Mock{}},
		{"get unknown column fails", "id = ?", []interface{}{1}, []string{"name", "foo", "bar"},
			database.ErrQueryFailed, nil},
		{"get broken query", "id = ? >", []interface{}{1}, []string{"name"},
			database.ErrQueryFailed, nil},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			p, err := op.GetByQuery(ctx, tt.columns, tt.clause, tt.values...)
			if !errors.Is(err, tt.err) {
				t.Errorf("Unexpected error. Expected %v, got %v.", tt.err, err)
			}

			if tt.err != nil {
				if p != nil {
					t.Errorf("Unexpected return value. Expected %v, got %v instead.",
						tt.expected, p)
				}
				return
			}

			for i, e := range tt.expected {
				if !reflect.DeepEqual(p[i], e) {
					t.Errorf("Unexpected *Mock{} %d. Expected %v, got %v.", i, e, p[i])
				}
			}
		})
	}
}

func TestInsertByQuery(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	db, err := mockDatabase()
	if err != nil {
		t.Fatalf("Failed to get DB: %v", err)
	}

	op := mockOperator(db)

	columns := []string{"name", "config"}

	obj := Mock{Name: "foo", MockAttributes: MockAttributes{Something: "bar"}}

	testCases := []struct {
		name     string
		input    Mock
		columns  []string
		err      error
		expected *Mock
	}{
		{"insert all", obj, []string{"name", "config"},
			nil, &Mock{Name: "foo", MockAttributes: MockAttributes{Something: "bar"}}},
		{"insert name only", obj, []string{"name"},
			nil, &Mock{Name: "foo", MockAttributes: MockAttributes{Something: ""}}},
		{"insert config only", obj, []string{"config"},
			nil, &Mock{Name: "", MockAttributes: MockAttributes{Something: "bar"}}},
		{"insert unknown columns fails", obj, []string{"config", "foo", "bar"},
			model.ErrUnknownColumn, nil},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			id, err := op.InsertByQuery(ctx, &tt.input, tt.columns, "")
			if !errors.Is(err, tt.err) {
				t.Errorf("Unexpected error. Expected %v, got %v.", tt.err, err)
			}

			if tt.err != nil {
				return
			}

			p, err := op.GetByID(ctx, columns, id)
			if err != nil {
				t.Fatalf("Unexpected error: %v.", err)
			}

			m, ok := p.(*Mock)
			if !ok {
				t.Fatal("MockDB.GetByID didn't return a *Mock{} instance")
			}

			tt.expected.ID = id
			if !reflect.DeepEqual(m, tt.expected) {
				t.Errorf("Unexpected name. Expected %q, got %q.", tt.expected, m)
			}
		})
	}
}

func TestUpdateByQuery(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	columns := []string{"name", "config"}

	obj := Mock{ID: 1, Name: "foo", MockAttributes: MockAttributes{Something: "bar"}}

	testCases := []struct {
		name     string
		input    Mock
		columns  []string
		clause   string
		values   []interface{}
		err      error
		expected *Mock
	}{
		{"update all", obj, []string{"name", "config"}, "id = ?", []interface{}{1},
			nil, &Mock{Name: "foo", MockAttributes: MockAttributes{Something: "bar"}}},
		{"update name only", obj, []string{"name"}, "id = ?", []interface{}{1},
			nil, &Mock{Name: "foo", MockAttributes: MockAttributes{Something: "else"}}},
		{"update config only", obj, []string{"config"}, "id = ?", []interface{}{1},
			nil, &Mock{Name: "test", MockAttributes: MockAttributes{Something: "bar"}}},
		{"update unknown columns fails", obj, []string{"config", "foo", "bar"}, "id = ?", []interface{}{1},
			model.ErrUnknownColumn, nil},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("Failed to get DB: %v", err)
			}

			op := mockOperator(db)

			id, err := op.UpdateByQuery(ctx, &tt.input, tt.columns, tt.clause, tt.values...)
			if !errors.Is(err, tt.err) {
				t.Errorf("Unexpected error. Expected %v, got %v.", tt.err, err)
			}

			if tt.err != nil {
				return
			}

			p, err := op.GetByID(ctx, columns, id)
			if err != nil {
				t.Fatalf("Unexpected error: %v.", err)
			}

			m, ok := p.(*Mock)
			if !ok {
				t.Fatal("MockDB.GetByID didn't return a *Mock{} instance")
			}

			tt.expected.ID = id
			if !reflect.DeepEqual(m, tt.expected) {
				t.Errorf("Unexpected name. Expected %q, got %q.", tt.expected, m)
			}
		})
	}
}

func TestMigrate(t *testing.T) {
	// t.Parallel()

	ctx := context.Background()

	columns := []string{"name", "value", "config"}

	testCases := []struct {
		name   string
		id     int64
		before *Mock
		after  *Mock
	}{
		{"get up-to-date", 1,
			&Mock{ID: 1, Name: "test", MockAttributes: MockAttributes{Something: "else"}},
			&Mock{ID: 1, Name: "test", MockAttributes: MockAttributes{Something: "else"}},
		},
		{"get outdated", 2,
			&Mock{ID: 2, Name: "outdated", MockAttributes: MockAttributes{Something: "else"}},
			&Mock{ID: 2, Name: "updated", Value: "moved", MockAttributes: MockAttributes{Something: "else"}},
		},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			// t.Parallel()

			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("Failed to get DB: %v", err)
			}

			op := mockOperator(db)

			p, err := op.GetByID(ctx, columns, tt.id)
			if err != nil {
				t.Errorf("Unexpected error: %v", err)
			}

			if !reflect.DeepEqual(p, tt.before) {
				t.Errorf("Unexpected %T. Expected %q, got %q.",
					tt.before, tt.before, p)
			}

			err = op.Migrate(ctx)
			if err != nil {
				t.Fatalf("Migration failed: %v", err)
			}

			p, err = op.GetByID(ctx, columns, tt.id)
			if err != nil {
				t.Errorf("Unexpected error: %v", err)
			}

			if !reflect.DeepEqual(p, tt.after) {
				t.Errorf("Unexpected %T: Expected %q, got %q.",
					tt.after, tt.after, p)
			}
		})
	}
}
