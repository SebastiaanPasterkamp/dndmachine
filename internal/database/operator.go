package database

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
)

// GetByID returns a persistable model by the primary key.
func (o Operator) GetByID(ctx context.Context, db Instance, columns []string, id int64) (Persistable, error) {
	return o.GetOneByQuery(ctx, db, columns, "id = ?", id)
}

// GetOneByQuery returns a single persistable model by the provided query.
func (o Operator) GetOneByQuery(ctx context.Context, db Instance, columns []string, clause string, args ...interface{}) (Persistable, error) {
	var query strings.Builder

	fmt.Fprintf(&query, "SELECT %s, `id` FROM %s", columnSQL(columns), o.Table)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return nil, fmt.Errorf("%w: failed to prepare %q: %v",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	r := stmt.QueryRowContext(ctx, args...)

	obj, err := o.NewFromRow(r, columns)
	switch {
	case errors.Is(err, sql.ErrNoRows):
		return nil, fmt.Errorf("select failed: %w: Object %T not found", ErrNotFound, obj)
	case err != nil:
		return nil, fmt.Errorf("%w: cannot select %T from result: %v", ErrQueryFailed, obj, err)
	}

	return obj, nil
}

// GetByQuery returns zero or persistables by the provided query.
func (o Operator) GetByQuery(ctx context.Context, db Instance, columns []string, clause string, args ...interface{}) ([]Persistable, error) {
	var (
		objs  []Persistable
		query strings.Builder
	)

	fmt.Fprintf(&query, "SELECT %s, `id` FROM %s", columnSQL(columns), o.Table)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return objs, fmt.Errorf("%w: failed to prepare %q: %v",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	r, err := stmt.QueryContext(ctx, args...)
	if err != nil {
		switch {
		case errors.Is(err, sql.ErrNoRows):
			return objs, fmt.Errorf("select failed: %w", ErrNotFound)
		case err != nil:
			return nil, fmt.Errorf("%w: cannot select from result: %v", ErrQueryFailed, err)
		}
	}
	defer r.Close()

	for r.Next() {
		obj, err := o.NewFromRow(r, columns)
		if err != nil {
			switch {
			case errors.Is(err, sql.ErrNoRows):
				return objs, fmt.Errorf("select failed: %w: Object %T not found", ErrNotFound, obj)
			case err != nil:
				return nil, fmt.Errorf("%w: cannot select %T from result: %v", ErrQueryFailed, obj, err)
			}
		}
		objs = append(objs, obj)
	}

	return objs, nil
}

// InsertByQuery adds a persistable to the database, with an optional query, and
// returns the newly inserted id.
func (o Operator) InsertByQuery(ctx context.Context, db Instance, obj Persistable, columns []string, clause string, args ...interface{}) (int64, error) {
	var query strings.Builder
	fmt.Fprintf(&query, "INSERT INTO %s (%s) VALUES (%s)",
		o.Table, columnSQL(columns), placeholderSQL(columns))
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return 0, fmt.Errorf("%w: failed to prepare %q: %v",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	fields, err := obj.ExtractFields(columns)
	if err != nil {
		return 0, fmt.Errorf("failed to get fields %q from %T: %w", columns, obj, err)
	}
	fields = append(fields, args...)

	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return 0, fmt.Errorf("%w: cannot insert object %T: %v",
			ErrQueryFailed, obj, err)
	}

	id, err := r.LastInsertId()
	if err != nil {
		return 0, fmt.Errorf("%w: failed to get ID after insert of %T: %v",
			ErrQueryFailed, obj, err)
	}

	return id, nil
}

// UpdateByQuery updates one model in the database, and returns the affected id.
func (o Operator) UpdateByQuery(ctx context.Context, db Instance, obj Persistable, columns []string, clause string, args ...interface{}) (int64, error) {
	var query strings.Builder
	fmt.Fprintf(&query, "UPDATE %s SET %s", o.Table, updateSQL(columns))
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return obj.GetID(), fmt.Errorf("%w: failed to prepare %q: %v",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	fields, err := obj.ExtractFields(columns)
	if err != nil {
		return 0, fmt.Errorf("failed to get fields %q from %T: %w", columns, obj, err)
	}
	fields = append(fields, args...)

	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return obj.GetID(), fmt.Errorf("failed to update object %T: %w", obj, err)
	}

	rows, err := r.RowsAffected()
	if err != nil {
		return obj.GetID(), fmt.Errorf("failed to get results for update of %T: %w", obj, err)
	}

	switch rows {
	case 0:
		return obj.GetID(), fmt.Errorf("update failed: %v: Object %T not found", ErrNotFound, obj)
	case 1:
		// pass
	default:
		return obj.GetID(), fmt.Errorf("unexpected number of updates of %T: %d", obj, rows)
	}

	return obj.GetID(), nil
}

func columnSQL(fields []string) string {
	return strings.Join(fields, ", ")
}

func updateSQL(fields []string) string {
	return strings.Join(fields, " = ?, ") + " = ?"
}

func placeholderSQL(fields []string) string {
	return strings.Repeat(", ?", len(fields))[2:]
}
