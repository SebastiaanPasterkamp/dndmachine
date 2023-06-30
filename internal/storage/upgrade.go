package storage

import (
	"context"
	"errors"
	"fmt"
	"io"
	"log"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
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

			log.Printf("🗸 %s %q : %q\n", schema.Version, schema.Path, schema.Description)

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

	userDB := database.Operator{
		DB:    db,
		Table: "user",
		Create: func() model.Persistable {
			return &model.User{}
		},
		Read: func(r io.Reader) (model.Persistable, error) {
			p := model.User{}
			err := p.UnmarshalFromReader(r)
			return &p, err
		},
	}

	if err := userDB.Migrate(ctx); err != nil {
		return fmt.Errorf("failed to upgrade user modules: %w", err)
	}

	equipmentDB := database.Operator{
		DB:    db,
		Table: "equipment",
		Create: func() model.Persistable {
			return &model.Equipment{}
		},
		Read: func(r io.Reader) (model.Persistable, error) {
			p := model.Equipment{}
			err := p.UnmarshalFromReader(r)
			return &p, err
		},
	}

	if err := equipmentDB.Migrate(ctx); err != nil {
		return fmt.Errorf("failed to upgrade equipment modules: %w", err)
	}

	return nil
}
