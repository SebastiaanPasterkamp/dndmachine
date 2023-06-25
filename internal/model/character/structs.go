package character

import (
	"encoding/json"
)

// UUID is a string-type representing a unique 32-byte ID.
type UUID string

// Object is the database.Persistable and api.JSONable implementation of a
// character model.
type Object struct {
	Attributes
	ID     int64  `json:"id"`
	UserID int64  `json:"userID"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

// Attributes are a collection of non-primary fields stored in the
// config column of the character table.
type Attributes struct {
	Choices map[UUID]json.RawMessage `json:"choices"`
}
