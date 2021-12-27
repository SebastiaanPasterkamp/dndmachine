package storage_test

import (
	"bytes"
	"errors"
	"os"
	"testing"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

func TestNewSchemaChange(t *testing.T) {
	var testCases = []struct {
		name            string
		path            string
		expectedDesc    string
		expectedVersion string
		expectedError   error
	}{
		{"Good", "testdata/good_schemas/0.0.1.init.sql",
			"First schema file", "0.0.1", nil},
		{"Bad version", "testdata/bad_version/bad_version.sql",
			"", "0.0.0", storage.ErrInvalidVersion},
		{"Missing header", "testdata/missing_header/0.1.0.empty.sql",
			"", "0.1.0", storage.ErrMissingSchemaDescription},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			s, err := storage.NewSchemaChange(tt.path)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q",
					tt.expectedError, err)
			}

			if s.Path != tt.path {
				t.Errorf("Unexpected path. Expected %q, got %q",
					tt.path, s.Path)
			}

			if s.Description != tt.expectedDesc {
				t.Errorf("Unexpected description. Expected %q, got %q",
					tt.expectedDesc, s.Description)
			}

			if s.Version.String() != tt.expectedVersion {
				t.Errorf("Unexpected version. Expected %q, got %q",
					tt.expectedVersion, s.Version.String())
			}
		})
	}
}

func TestRead(t *testing.T) {
	var testCases = []struct {
		name            string
		path            string
		expectedError   error
		expectedContent string
	}{
		{"Working", "testdata/good_schemas/0.0.1.init.sql",
			nil, "-- First schema file\n\nDROP TABLE IF EXISTS `user`;\nCREATE TABLE `user` (\n  `id` INTEGER PRIMARY KEY AUTOINCREMENT\n);\n"},
		{"Bad path", "testdata/missing.sql",
			os.ErrNotExist, ""},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			s := storage.SchemaChange{
				Path: tt.path,
			}

			r, err := s.Reader()

			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q.",
					tt.expectedError, err)
			}

			if tt.expectedError != nil {
				return
			}

			b := bytes.Buffer{}
			_, err = b.ReadFrom(r)

			if err != nil {
				t.Errorf("Unexpected error: %q.", err)
			}

			if b.String() != tt.expectedContent {
				t.Errorf("Unexpected content. Expected %q, got %q.",
					tt.expectedContent, b.String())
			}
		})
	}
}

func TestListSchemaDir(t *testing.T) {
	var testCases = []struct {
		name          string
		path          string
		expectedCount int
		expectedError error
	}{
		{"Good", "testdata/good_schemas",
			4, nil},
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
			s, err := storage.ListSchemaDir(tt.path)
			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error. Expected %q, got %q",
					tt.expectedError, err)
			}

			if len(s) != tt.expectedCount {
				t.Errorf("Unexpected schema count. Expected %d, got %d",
					tt.expectedCount, len(s))
			}
		})
	}
}
