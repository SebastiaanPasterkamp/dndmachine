package service

import (
	"fmt"
)

var (
	// ErrForcedShutdown is returned if a /ready probe did not occur within the
	// configured MaxShutdownDelay.
	ErrForcedShutdown = fmt.Errorf("shutdown forced")
)
