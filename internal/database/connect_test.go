package database_test

import (
	"errors"
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func TestConnect(t *testing.T) {
	testCases := []struct {
		name          string
		DSN           func() string
		expectedError error
	}{
		{"Working", func() string { return fmt.Sprintf("sqlite://file:memory-%d.db?mode=memory&cache=shared", rand.Int()) },
			nil},
		{"Bad DSN", func() string { return "foobar" },
			database.ErrMalformedDNS},
		{"Unsupported driver", func() string { return "bad://driver" },
			database.ErrUnsupportedDriver},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			cfg := database.Configuration{
				DSN:             tt.DSN(),
				ConnMaxLifetime: 15 * time.Minute,
				MaxIdleConns:    1,
				MaxOpenConns:    1,
				PingTimeout:     1 * time.Second,
			}

			db, err := database.Connect(cfg)
			defer func() {
				if err := db.Close(); err != nil {
					t.Errorf("Unexpected error closing the database: %v", err)
				}
			}()

			if !errors.Is(err, tt.expectedError) {
				t.Errorf("Unexpected error: Expected %q, got %q", tt.expectedError, err)
			}
		})
	}
}

func TestIsConnected(t *testing.T) {
	testCases := []struct {
		name             string
		DSN              func() string
		expectConnection bool
	}{
		{"Working", func() string {
			return fmt.Sprintf("sqlite://file:working-connect-%d.db?mode=memory&cache=shared", rand.Int())
		},
			true},
		{"Working alternative", func() string { return fmt.Sprintf("sqlite3://file:memory-%d.db?mode=memory&cache=shared", rand.Int()) },
			true},
		{"Unreachable database", func() string { return "mysql://foo:bar@tcp(127.0.0.1:3306)/connected?timeout=1s" },
			false},
	}

	for _, tt := range testCases {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
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

			ping := db.IsConnected()
			if ping != tt.expectConnection {
				t.Errorf("Unexpected connection result. Expected %v, got %v",
					tt.expectConnection, ping)
			}
		})
	}
}
