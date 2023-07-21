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

	// ErrTransactionFailed is returned when the transaction could not be
	// started.
	ErrTransactionFailed = fmt.Errorf("failed to start a transaction")
	// ErrListingChangesFailed is returned when the directory with schema
	// changes could not be read.
	ErrListingChangesFailed = fmt.Errorf("failed to list available schema changes")
	// ErrInitVersioning is the error returned when the table containing the
	// schema changes could not be created.
	ErrInitVersioning = fmt.Errorf("failed to start schema versioning")
	// ErrSchemaReadFailed is the error returned if the schema file could not be
	// read.
	ErrSchemaReadFailed = fmt.Errorf("failed to read schema")
	// ErrSchemaApplyFailed is the error returned if the schema could not be
	// applied to the database.
	ErrSchemaApplyFailed = fmt.Errorf("failed to apply schema")
	// ErrSchemaRecordingFailed is the error returned if the application of the
	// schema could not be recorded.
	ErrSchemaRecordingFailed = fmt.Errorf("failed to record having applied schema")
	// ErrSchemaUnknownStatus is the error returned if the schema status cannot
	// be verified.
	ErrSchemaUnknownStatus = fmt.Errorf("cannot determine if schema has already been applied")
	// ErrFailedCommit is returned when the committing the database changes
	// failed.
	ErrFailedCommit = fmt.Errorf("failed to commit version upgrades")

	// ErrMigrationFailed is returned when a model migration (upgrade) failed.
	ErrMigrationFailed = fmt.Errorf("failed to upgrade modules")
)
