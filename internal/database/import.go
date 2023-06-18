package database

import (
	"bytes"
	"context"
	"database/sql"
	"fmt"
	"io"
)

// Import executes SQL from a reader into the database instance.
func (i *Instance) Import(fh io.Reader) error {
	if err := i.Ping(); err != nil {
		return err
	}

	ctx := context.Background()

	tx, err := i.Pool.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() {
		_ = tx.Rollback()
	}()

	err = ImportToDB(tx, fh)
	if err != nil {
		return fmt.Errorf("failed to import to DB: %w", err)
	}

	err = tx.Commit()
	if err != nil {
		return fmt.Errorf("failed to commit import to DB: %w", err)
	}

	return nil
}

// ImportToDB executes SQL from a reader within the database transaction.
func ImportToDB(db *sql.Tx, fh io.Reader) error {
	buf := bytes.Buffer{}
	_, err := io.Copy(&buf, fh)
	if err != nil {
		return fmt.Errorf("error while reading sql code to import: %w", err)
	}

	if _, err = db.Exec(buf.String()); err != nil {
		return fmt.Errorf("%w: %q", ErrImportFailed, err)
	}

	return nil
}
