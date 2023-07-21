package storage_test

import (
	"errors"
	"fmt"
	"math/rand"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

func TestImportCommand(t *testing.T) {
	var testCases = []struct {
		name          string
		args          storage.CmdImport
		expectedError error
		workingQuery  string
		failingQuery  string
	}{
		{"Good", storage.CmdImport{Source: "testdata/good_schemas/0.0.1.init.sql"},
			nil, "SELECT count(*) FROM user", ""},
		{"Invalid version allowed", storage.CmdImport{Source: "testdata/bad_version/bad_version.sql"},
			nil, "SELECT count(*) FROM user", ""},
		{"Empty allowed", storage.CmdImport{Source: "testdata/missing_header/0.1.0.empty.sql"},
			nil, "", "SELECT count(*) FROM user"},
		{"Bad SQL fails", storage.CmdImport{Source: "testdata/corrupt_sql/0.0.1.init.sql"},
			storage.ErrSchemaApplyFailed, "", "SELECT count(*) FROM user"},
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
				Import: &tt.args,
			}

			err = cfg.Command(db)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q",
					tt.expectedError, err)
			}

			if tt.workingQuery != "" {
				if _, err = db.Pool.Exec(tt.workingQuery); err != nil {
					t.Errorf("Unexpected error running %q: %v", tt.workingQuery, err)
				}
			}

			if tt.failingQuery != "" {
				if _, err = db.Pool.Exec(tt.failingQuery); err == nil {
					t.Errorf("Expected error running %q, got nil", tt.failingQuery)
				}
			}
		})
	}
}
