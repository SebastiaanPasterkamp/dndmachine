package storage

import (
	"errors"
	"fmt"
	"log"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func (s *Instance) version(db database.Instance) error {
	schemas, err := ListSchemaDir(s.Path)
	if err != nil {
		return err
	}

	for _, schema := range schemas {
		dt, err := schema.ApplicationDate(db)

		switch {
		case err == nil:
			log.Printf("🗸 %s %q @ %v : %q\n", schema.Version, schema.Path, dt, schema.Description)
		case errors.Is(err, ErrNotApplied):
			log.Printf("x %s %q : %q\n", schema.Version, schema.Path, schema.Description)
		default:
			return fmt.Errorf("cannot determine if schema %s %q has already been applied: %w",
				schema.Version, schema.Path, err)
		}
	}

	return nil
}
