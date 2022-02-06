package database_test

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"math/rand"
	"os"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func mockDatabase() (database.Instance, error) {
	dsn := fmt.Sprintf("sqlite://file:test-%d.db?mode=memory&cache=shared", rand.Int())

	db, err := database.Connect(database.Configuration{
		DSN:          dsn,
		MaxOpenConns: 2,
		MaxIdleConns: 2,
	})
	if err != nil {
		return db, fmt.Errorf("failed to open %q, %w", dsn, err)
	}

	mockdb := "testdata/mock.sql"
	fh, err := os.Open(mockdb)
	if err != nil {
		return db, fmt.Errorf("failed to open %q: %w", mockdb, err)
	}
	defer fh.Close()

	err = db.Import(fh)
	if err != nil {
		return db, fmt.Errorf("failed to open %q: %w", mockdb, err)
	}

	return db, nil
}

type Mock struct {
	MockAttributes
	ID    int64  `json:"id"`
	Name  string `json:"name"`
	Value string `json:"value"`
}

type MockAttributes struct {
	Something string `json:"something"`
}

func (m Mock) GetID() int64 {
	return m.ID
}

// ExtractFields returns mock attributes in order specified by the columns argument.
func (m Mock) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = m.ID
		case "name":
			fields[i] = m.Name
		case "value":
			if m.Value != "" {
				fields[i] = m.Value
			} else {
				fields[i] = sql.NullString{}
			}
		case "config":
			config, err := json.Marshal(m.MockAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the mock object with values contained in the
// database.Scanner.
func (m *Mock) UpdateFromScanner(row database.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &m.ID
		case "name":
			fields[i] = &m.Name
		case "value":
			var value sql.NullString
			fields[i] = &value
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to scan fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "value":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				m.Value = value.String
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &m.MockAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// Migrate adjusts a Mock object to any changes between versions. This example
// transfers a field from the MockAttributes to the main Mock object.
func (m *Mock) Migrate(row database.Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &m.ID
		case "name":
			fields[i] = &m.Name
		case "value":
			var value sql.NullString
			fields[i] = &value
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to migrate fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "value":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				m.Value = value.String
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &m.MockAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q for attributes: %w", column, err)
			}
			if err := json.Unmarshal(config, m); err != nil {
				return fmt.Errorf("failed to unmarshal %q for object: %w", column, err)
			}
		}
	}

	return nil
}

var MockDB = database.Operator{
	Table: "mock",
	NewPersistable: func() database.Persistable {
		return &Mock{}
	},
}
