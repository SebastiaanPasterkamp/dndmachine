package options

import (
	"fmt"
)

var (
	// ErrUnknownOption is the error returned if the option type is not known.
	ErrUnknownOption = fmt.Errorf("unknown option type")
	// ErrMalformedOption is the error returned if the option configuration
	// could not be read.
	ErrMalformedOption = fmt.Errorf("malformed option configuration")
	// ErrMalformedChoice is the error returned if the option choice in the
	// character could not be read.
	ErrMalformedChoice = fmt.Errorf("malformed choice configuration")
)
