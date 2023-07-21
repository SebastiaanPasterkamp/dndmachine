package storage

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func (s *Instance) import_(db database.Instance, cfg CmdImport) error {
	ctx := context.Background()

	r, err := os.Open(cfg.Source)
	if err != nil {
		return fmt.Errorf("%w: %q: %w", ErrSchemaReadFailed, cfg.Source, err)
	}

	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("%w: %w", ErrTransactionFailed, err)
	}

	err = database.ImportToDB(tx, r)
	if err != nil {
		_ = tx.Rollback()

		return fmt.Errorf("%w: %q: %w", ErrSchemaApplyFailed, cfg.Source, err)
	}

	log.Printf("🗸 %q\n", cfg.Source)

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("%w: %q: %w", ErrFailedCommit, cfg.Source, err)
	}

	return nil
}
