package characteristic

import "fmt"

var (
	// ErrNotYetImplemented is the error returned if a feature is not yet
	// available.
	ErrNotYetImplemented = fmt.Errorf("not yet implemented")
	// ErrFailedToApply is the error returned if an option could not be applied
	// to the character Object.
	ErrFailedToApply = fmt.Errorf("failed to apply")
)
