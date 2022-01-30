package api

import (
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

// JSONable is an interface to a struct that can be converted to and from JSON,
// and get updated from a JSON payload.
type JSONable interface {
	UnmarshalFromReader(r io.Reader) error
	MarshalToWriter(w io.Writer) error
}

// NewPersistable turns an io.Reader into a database persistable object.
type NewPersistable func(io.Reader) (database.Persistable, error)
