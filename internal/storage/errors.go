package storage

import (
	"fmt"
)

var (
	// ErrUnknownSubcommand is the error returned if no known subcommand is
	// given.
	ErrUnknownSubcommand = fmt.Errorf("missing subcommand")

	// ErrNotApplied is the error returned if a schema is not applied.
	ErrNotApplied = fmt.Errorf("schema has not been applied")
	// ErrOutOfOrder is the error returned if a sequence of schema changes has
	// been applied out-of-order.
	ErrOutOfOrder = fmt.Errorf("schema has been applied out of order")

	// ErrInvalidVersion is the error returned if the schema change filename
	// does not start with a semver version: x.y.z.name.sql.
	ErrInvalidVersion = fmt.Errorf("failed to determine schema version")
	// ErrMissingSchemaDescription is the error returned in the schema file is
	// missing the description header line.
	ErrMissingSchemaDescription = fmt.Errorf("failed read description")
)
