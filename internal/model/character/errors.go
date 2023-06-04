package character

import "fmt"

var (
	// ErrMalformedPath is the error returned if a path is not properly
	// formatted.
	ErrMalformedPath = fmt.Errorf("malformed path")
	// ErrPathNotFound is the error returned if a path does not exist.
	ErrPathNotFound = fmt.Errorf("path not found")
	// ErrInvalidPath is the error returned if a path does not match the
	// expected type.
	ErrInvalidPath = fmt.Errorf("invalid path")
	// ErrUnsupportedOperation is the error returned at an attempt to update a
	// non-pointer subject.
	ErrUnsupportedOperation = fmt.Errorf("unsupported operation")
)
