package database

import (
	"fmt"
)

var (
	// ErrMalformedDNS is the error returned if the database DSN does not adhere
	// to the expected format.
	ErrMalformedDNS = fmt.Errorf("DSN should have format 'name://source'")
	// ErrUnsupportedDriver is the error returned if the DSN does not specify
	// either mysql://, or sqlite:// as driver name.
	ErrUnsupportedDriver = fmt.Errorf("unsupported database driver")
	// ErrNoConnection is the error returned if database actions are performed
	// without establishing a connection (pool) with the database.
	ErrNoConnection = fmt.Errorf("no connection")

	// ErrImportFailed is the error returned if a sequence of sql statements to
	// import failed.
	ErrImportFailed = fmt.Errorf("failed to import sql code")
	// ErrNotFound is the error returned if the requested object does not exist
	// in the database.
	ErrNotFound = fmt.Errorf("object not found")
	// ErrInsertFailed is the error returned if the insert failed.
	ErrInsertFailed = fmt.Errorf("failed to insert")
	// ErrUpdateFailed is the error returned if the update failed.
	ErrUpdateFailed = fmt.Errorf("failed to update")
	// ErrQueryFailed is the error returned if a database statement failed.
	ErrQueryFailed = fmt.Errorf("query failed")

	// ErrUnknownColumn is the error returned if a specified column is unknown
	// for the Persistable.
	ErrUnknownColumn = fmt.Errorf("unknown column")
)
