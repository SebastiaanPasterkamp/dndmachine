package storage

import (
	"context"
	"errors"
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func (s *Instance) upgrade(db database.Instance, cfg CmdUpgrade) error {
	ctx := context.Background()

	schemas, err := ListSchemaDir(s.Path)
	if err != nil {
		return fmt.Errorf("failed to list available schema changes: %w", err)
	}

	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("failed to start a transaction: %w", err)
	}

	if err := initialize(tx); err != nil {
		_ = tx.Rollback()
		return fmt.Errorf("failed to start schema versioning: %w", err)
	}

	newChanges := false

	for _, schema := range schemas {
		_, err := schema.applicationDate(tx)

		switch {
		case err == nil:
			// Schema already applied
			if newChanges && cfg.RejectOutOfOrder {
				_ = tx.Rollback()

				return fmt.Errorf("%w: %s %q", ErrOutOfOrder,
					schema.Version.String(), schema.Path)
			}
		case errors.Is(err, ErrNotApplied):
			r, err := schema.Reader()
			if err != nil {
				return fmt.Errorf("failed to read schema %s %q: %w",
					schema.Version.String(), schema.Path, err)
			}

			err = database.ImportToDB(tx, r)
			if err != nil {
				_ = tx.Rollback()

				return fmt.Errorf("failed to apply schema %s %q: %w",
					schema.Version.String(), schema.Path, err)
			}

			if _, err := schema.register(tx); err != nil {
				_ = tx.Rollback()

				return fmt.Errorf("failed to record having applied schema %s %q: %w",
					schema.Version.String(), schema.Path, err)
			}

			newChanges = true
		default:
			_ = tx.Rollback()

			return fmt.Errorf("cannot determine if schema %s %q has already been applied: %w",
				schema.Version.String(), schema.Path, err)
		}
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("failed to commit version upgrades: %w", err)
	}

	return nil
}
