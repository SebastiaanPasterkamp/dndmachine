package policy

import (
	"fmt"
)

var (
	// ErrMissingUnknowns is the error returned in Partial is called without
	// a list of unknown variables to construct partial SQL from.
	ErrMissingUnknowns = fmt.Errorf("cannot create partial query without unknowns")
	// ErrOperatorNotSupported is the error returned if the partial rego rule
	// uses an operator that cannot be translated to SQL (yet).
	ErrOperatorNotSupported = fmt.Errorf("invalid expression: operator not supported")
)
