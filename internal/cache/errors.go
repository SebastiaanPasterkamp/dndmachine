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
)
