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
	Result
	ID     int64  `json:"id"`
	UserID int64  `json:"user_id"`
	Name   string `json:"name"`
	Level  int    `json:"level"`
}

// Attributes are a collection of non-primary fields stored in the
// config column of the character table.
type Attributes struct {
	Avatar  string                   `json:"avatar"`
	Choices map[UUID]json.RawMessage `json:"choices"`
}

// Result contains all computed attributes that can be set through the attribute
// choices.
type Result struct {
	Classes map[string]Class `json:"classes"`
}

// Class is a collection of class specific attributes.
type Class struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Level int    `json:"level"`
}
