package storage

import (
	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"

	"fmt"
)

func (s *Instance) Command(db database.Instance) error {
	switch {
	case s.Upgrade != nil:
		if err := s.upgrade(db, *s.Upgrade); err != nil {
			return fmt.Errorf("failed to update schema version: %w", err)
		}
	case s.Version != nil:
		if err := s.version(db); err != nil {
			return fmt.Errorf("failed to list storage version: %w", err)
		}
	case s.Import != nil:
		return fmt.Errorf("Not yet implemented.")
	case s.Export != nil:
		return fmt.Errorf("Not yet implemented.")
	default:
		return ErrUnknownSubcommand
	}

	return nil
}
