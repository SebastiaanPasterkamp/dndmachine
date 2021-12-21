package config

import (
	"fmt"
)

var (
	// ErrMissingSubcommand is the error returned if no subcommand is given.
	ErrMissingSubcommand = fmt.Errorf("missing subcommand")
)
