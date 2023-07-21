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
		return fmt.Errorf("%w: %w", ErrListingChangesFailed, err)
	}

	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("%w: %w", ErrTransactionFailed, err)
	}

	if err := initialize(tx); err != nil {
		_ = tx.Rollback()
		return fmt.Errorf("%w: %w", ErrInitVersioning, err)
	}

	newChanges := false

	for _, schema := range schemas {
		_, err := schema.applicationDate(tx)

		switch {
		case err == nil:
			// Schema already applied
			if newChanges && cfg.RejectOutOfOrder {
				_ = tx.Rollback()

				return fmt.Errorf("%w: %q from %q", ErrOutOfOrder,
					schema.Version.String(), schema.Path)
			}
		case errors.Is(err, ErrNotApplied):
			r, err := schema.Reader()
			if err != nil {
				return fmt.Errorf("%w: %q from %q: %w",
					ErrSchemaReadFailed, schema.Version.String(), schema.Path, err)
			}

			err = database.ImportToDB(tx, r)
			if err != nil {
				_ = tx.Rollback()

				return fmt.Errorf("%w: %q from %q: %w",
					ErrSchemaApplyFailed, schema.Version.String(), schema.Path, err)
			}

			if _, err := schema.register(tx); err != nil {
				_ = tx.Rollback()

				return fmt.Errorf("%w: %q from %q: %w",
					ErrSchemaRecordingFailed, schema.Version.String(), schema.Path, err)
			}

			log.Printf("🗸 %s %q : %q\n", schema.Version, schema.Path, schema.Description)

			newChanges = true
		default:
			_ = tx.Rollback()

			return fmt.Errorf("%w: %q from %q: %w",
				ErrSchemaUnknownStatus, schema.Version.String(), schema.Path, err)
		}
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("%w: %w", ErrFailedCommit, err)
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
		return fmt.Errorf("%w %q: %w", ErrMigrationFailed, "user", err)
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
		return fmt.Errorf("%w %q: %w", ErrMigrationFailed, "equipment", err)
	}

	return nil
}
