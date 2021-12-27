package storage_test

import (
	"errors"
	"os"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

func TestVersionCommand(t *testing.T) {
	var testCases = []struct {
		name          string
		path          string
		expectedCount int
		expectedError error
	}{
		{"Good", "testdata/good_schemas",
			3, nil},
		{"Not a directory", "testdata/nonexistent",
			0, os.ErrNotExist},
		{"Bad version", "testdata/bad_version",
			0, storage.ErrInvalidVersion},
		{"Missing header", "testdata/missing_header",
			0, storage.ErrMissingSchemaDescription},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			db, err := mockDatabase()
			if err != nil {
				t.Fatalf("Failed to init DB: %v", err)
			}
			defer db.Close()

			err = storage.Initialize(db)
			if err != nil {
				t.Fatalf("Failed to initialize DB: %v", err)
			}

			cfg := storage.Instance{
				Path:    tt.path,
				Version: &storage.CmdVersion{},
			}

			err = cfg.Command(db)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q",
					tt.expectedError, err)
			}
		})
	}
}
