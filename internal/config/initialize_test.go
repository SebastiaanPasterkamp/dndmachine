package config_test

import (
	"os"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/config"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/service"
)

func TestInitialize(t *testing.T) {
	var testCases = []struct {
		name     string
		args     string
		env      map[string]string
		error    bool
		expected config.Arguments
	}{
		{"Defaults", "./defaults serve", map[string]string{},
			false, config.Arguments{
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "8080"},
			},
		},
		{"CLI args over defaults", "./cli serve --port=9090", map[string]string{},
			false, config.Arguments{
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "9090"},
			},
		},
		{"Env over defaults", "./env serve", map[string]string{"DNDMACHINE_PORT": "6060"},
			false, config.Arguments{
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "6060"},
			},
		},
		{"File over defaults", "./file serve --config-path=testdata/config.json", map[string]string{},
			false, config.Arguments{
				Common: config.Common{ConfigPath: "testdata/config.json"},
				Configuration: database.Configuration{
					DSN:             "mysql://user:pwd@tcp(host:3306)/database",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "7070"},
			},
		},
		{"Cli over env", "./cli serve --port=9090", map[string]string{"DNDMACHINE_PORT": "6060"},
			false, config.Arguments{
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "9090"},
			},
		},
		{"CLI args over file", "./file serve --config-path=testdata/config.json --port=9090", map[string]string{},
			false, config.Arguments{
				Common: config.Common{ConfigPath: "testdata/config.json"},
				Configuration: database.Configuration{
					DSN:             "mysql://user:pwd@tcp(host:3306)/database",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "9090"},
			},
		},
		{"Env over file", "./env serve --config-path=testdata/config.json", map[string]string{"DNDMACHINE_PORT": "6060"},
			false, config.Arguments{
				Common: config.Common{ConfigPath: "testdata/config.json"},
				Configuration: database.Configuration{
					DSN:             "mysql://user:pwd@tcp(host:3306)/database",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
				Server: &service.Instance{Port: "6060"},
			},
		},
		{"Broken JSON", "./broken serve --config-path=/dev/null", map[string]string{},
			true, config.Arguments{
				Common: config.Common{ConfigPath: "/dev/null"},
				Server: &service.Instance{Port: "8080"},
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
			},
		},
		{"Give help", "./help --help", map[string]string{},
			false, config.Arguments{},
		},
		{"Give version", "./help --version", map[string]string{},
			false, config.Arguments{},
		},
		{"Bad port", "./bad --port nope", map[string]string{},
			true, config.Arguments{},
		},
		{"No command", "./incomplete", map[string]string{},
			true, config.Arguments{
				Configuration: database.Configuration{
					DSN:             "sqlite://machine.db",
					ConnMaxLifetime: 15 * time.Minute,
					MaxIdleConns:    3,
					MaxOpenConns:    3,
					PingTimeout:     3 * time.Second,
				},
			},
		},
	}

	for _, tt := range testCases {
		tt := tt
		// Can't run in parallel, because we manipulate environment variables
		t.Run(tt.name, func(t *testing.T) {
			defer func() {
				for name := range tt.env {
					os.Unsetenv(name)
				}
			}()
			for name, val := range tt.env {
				if err := os.Setenv(name, val); err != nil {
					t.Fatalf("Failed to set env %q=%q: %v", name, val, err)
				}
			}

			args, err := config.Initialize(split(tt.args))
			if err != nil && !tt.error {
				t.Errorf("Unexpected error: %v", err)
			}
			if err == nil && tt.error {
				t.Errorf("Expected error, got nil")
			}

			if !reflect.DeepEqual(args.Configuration, tt.expected.Configuration) {
				t.Errorf("Unexpected database result. Expected %v, got %v.",
					tt.expected.Configuration, args.Configuration)
			}

			if !reflect.DeepEqual(args.Server, tt.expected.Server) {
				t.Errorf("Unexpected server result. Expected %v, got %v.",
					tt.expected.Server, args.Server)
			}

			if !reflect.DeepEqual(args, tt.expected) {
				t.Errorf("Unexpected result. Expected %v, got %v.", tt.expected, args)
			}
		})
	}
}

func split(s string) []string {
	return strings.Split(s, " ")
}
