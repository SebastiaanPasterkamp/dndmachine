package database_test

import (
	"errors"
	"fmt"
	"math/rand"
	"os"
	"testing"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func TestImport(t *testing.T) {
	testCases := []struct {
		name          string
		DSN           func() string
		path          string
		expectedError error
		workingQuery  string
	}{
		{"Working", func() string { return fmt.Sprintf("sqlite://file:working-%d.db?mode=memory&cache=shared", rand.Int()) }, "testdata/schema_table.sql",
			nil, "SELECT * FROM schema"},
		{"Unreachable database", func() string { return "mysql://foo:bar@tcp(127.0.0.1:3306)/import?timeout=1s" }, "testdata/schema_table.sql",
			database.ErrNoConnection, ""},
		{"Bad query", func() string {
			return fmt.Sprintf("sqlite://file:bad-query-%d.db?mode=memory&cache=shared", rand.Int())
		}, "testdata/bad_query.sql",
			database.ErrImportFailed, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			cfg := database.Configuration{
				DSN:             tt.DSN(),
				ConnMaxLifetime: 15 * time.Minute,
				MaxIdleConns:    1,
				MaxOpenConns:    1,
				PingTimeout:     1 * time.Second,
			}

			db, err := database.Connect(cfg)
			if err != nil {
				t.Fatalf("Unexpected error connecting to the database: %v", err)
			}

			defer func() {
				if err := db.Close(); err != nil {
					t.Errorf("Unexpected error closing the database: %v", err)
				}
			}()

			fh, err := os.Open(tt.path)
			if err != nil {
				t.Fatalf("Failed to open schema file %q for testing: %v",
					tt.path, err)
			}
			defer fh.Close()

			err = db.Import(fh)

			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}

			if tt.expectedError == nil {
				if _, err = db.Pool.Exec(tt.workingQuery); err != nil {
					t.Errorf("Unexpected error running %q: %v", tt.workingQuery, err)
				}
			}
		})
	}
}
