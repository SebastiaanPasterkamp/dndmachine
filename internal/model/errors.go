package model

import (
	"fmt"
)

var (
	// ErrUnknownColumn is the error returned if a specified column is unknown
	// for the Persistable.
	ErrUnknownColumn = fmt.Errorf("unknown column")
	// ErrInvalidRecord is the error returned if scanning the database row did
	// not work as expected.
	ErrInvalidRecord = fmt.Errorf("invalid record")
)
