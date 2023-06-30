package model

import (
	"io"
)

// Persistable is an interface to a struct that can be stored in, and retrieved
// from a database.
type Persistable interface {
	GetID() int64
	ExtractFields(fields []string) ([]interface{}, error)
	UpdateFromScanner(row Scanner, columns []string) error
}

// Scanner is an interface that implements the Scan function. Scan is
// implemented by *sql.Row and *sql.Rows.
type Scanner interface {
	Scan(dest ...interface{}) error
}

// JSONable is an interface to a struct that can be converted to and from JSON,
// and get updated from a JSON payload.
type JSONable interface {
	UnmarshalFromReader(r io.Reader) error
}

// Migrator is an interface for a Persistable model that has migration code
// to make structure adjustments between versions.
type Migrator interface {
	GetID() int64
	Migrate(row Scanner, columns []string) error
}
