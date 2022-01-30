package database_test

import (
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
		MaxOpenConns: 1,
		MaxIdleConns: 1,
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
	ID   int64  `json:"id"`
	Name string `json:"name"`
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
		case "name":
			fields[i] = m.Name
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

var MockDB = database.Operator{
	Table: "mock",
	NewFromRow: func(row database.Scanner, columns []string) (database.Persistable, error) {
		m := Mock{}
		fields := make([]interface{}, len(columns)+1)
		fields[len(columns)] = &m.ID

		for i, column := range columns {
			switch column {
			case "name":
				fields[i] = &m.Name
			case "config":
				config := []byte{}
				fields[i] = &config
			default:
				return nil, fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
			}
		}

		if err := row.Scan(fields...); err != nil {
			return nil, err
		}

		for i, column := range columns {
			switch column {
			case "config":
				if err := json.Unmarshal(*fields[i].(*[]byte), &m.MockAttributes); err != nil {
					return nil, err
				}
			}
		}

		return &m, nil
	},
}
