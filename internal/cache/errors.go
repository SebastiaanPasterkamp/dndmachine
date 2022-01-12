package cache

import (
	"fmt"
)

var (
	// ErrBadConfig is the error returned if the factory cannot instantiate a
	// cache repository based on the provided configuration.
	ErrBadConfig = fmt.Errorf("cannot create cache repository from configuration")
	// ErrNotFound is the error returned if the requested item does not exist in
	// the cache repository.
	ErrNotFound = fmt.Errorf("item not found")
	// ErrNotStored is the error returned if the stored item cannot be stored in
	// the repository.
	ErrNotStored = fmt.Errorf("item not stored")
)
