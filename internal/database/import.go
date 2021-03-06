package database

import (
	"context"
	"database/sql"
	"fmt"
	"io"
	"io/ioutil"
)

func (i *Instance) Import(fh io.Reader) error {
	if !i.IsConnected() {
		return ErrNoConnection
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

func ImportToDB(db *sql.Tx, fh io.Reader) error {
	data, err := ioutil.ReadAll(fh)
	if err != nil {
		return fmt.Errorf("error while reading sql code to import: %w", err)
	}

	if _, err = db.Exec(string(data)); err != nil {
		return fmt.Errorf("%w: %q", ErrImportFailed, err)
	}

	return nil
}
