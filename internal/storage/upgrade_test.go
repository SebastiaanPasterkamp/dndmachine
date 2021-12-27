package storage_test

import (
	"errors"
	"fmt"
	"math/rand"
	"os"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

func TestUpgradeCommand(t *testing.T) {
	var testCases = []struct {
		name          string
		path          string
		prepare       string
		args          storage.CmdUpgrade
		expectedError error
		workingQuery  string
	}{
		{"Good", "testdata/good_schemas", "", storage.CmdUpgrade{},
			nil, "SELECT count(*) FROM user"},
		{"Out of order allowed", "testdata/good_schemas", "testdata/good_schemas/0.0.3.unrelated.sql", storage.CmdUpgrade{},
			nil, "SELECT count(*) FROM user"},
		{"Out of order rejected", "testdata/good_schemas", "testdata/good_schemas/0.0.3.unrelated.sql", storage.CmdUpgrade{RejectOutOfOrder: true},
			storage.ErrOutOfOrder, ""},
		{"Not a directory", "testdata/nonexistent", "", storage.CmdUpgrade{},
			os.ErrNotExist, ""},
		{"Bad version", "testdata/bad_version", "", storage.CmdUpgrade{},
			storage.ErrInvalidVersion, ""},
		{"Missing header", "testdata/missing_header", "", storage.CmdUpgrade{},
			storage.ErrMissingSchemaDescription, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			dsn := fmt.Sprintf("sqlite://file:test-%d.db?mode=memory&cache=shared", rand.Int())

			db, err := database.Connect(database.Configuration{
				DSN:          dsn,
				MaxOpenConns: 1,
				MaxIdleConns: 1,
			})
			if err != nil {
				t.Fatalf("Failed to init DB: %v", err)
			}
			defer db.Close()

			cfg := storage.Instance{
				Path:    tt.path,
				Upgrade: &tt.args,
			}

			if tt.prepare != "" {
				err := storage.Initialize(db)
				if err != nil {
					t.Fatalf("failed to initialize storage: %v", err)
				}

				s, err := storage.NewSchemaChange(tt.prepare)
				if err != nil {
					t.Fatalf("failed to prepare schema order: %v", err)
				}
				_, err = s.Register(db)
				if err != nil {
					t.Fatalf("failed to prepare schema order: %v", err)
				}
			}

			err = cfg.Command(db)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q",
					tt.expectedError, err)
			}

			if tt.expectedError == nil {
				if _, err = db.Pool.Exec(tt.workingQuery); err != nil {
					t.Errorf("Unexpected error running %q: %v", tt.workingQuery, err)
				}
			}
		})
	}
}
