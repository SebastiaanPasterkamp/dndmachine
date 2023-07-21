package database

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

// GetByID returns a persistable model by the primary key.
func (o Operator) GetByID(ctx context.Context, columns []string, id int64) (model.Persistable, error) {
	return o.GetOneByQuery(ctx, columns, "id = ?", id)
}

// GetOneByQuery returns a single persistable model by the provided query.
func (o Operator) GetOneByQuery(ctx context.Context, columns []string, clause string, args ...interface{}) (model.Persistable, error) {
	var query strings.Builder

	columns = append(columns, "id")
	fmt.Fprintf(&query, "SELECT %s FROM %s",
		selectSQL(o.Table, columns), o.Table)
	for _, join := range o.SelectJoin {
		query.WriteByte(' ')
		query.WriteString(join)
	}
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := o.DB.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return nil, fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	r := stmt.QueryRowContext(ctx, args...)

	obj := o.Create()

	err = obj.UpdateFromScanner(r, columns)
	switch {
	case errors.Is(err, sql.ErrNoRows):
		return nil, fmt.Errorf("select failed: %w: Object %T using %q not found",
			ErrNotFound, obj, query.String())
	case err != nil:
		return nil, fmt.Errorf("%w: cannot select %T from %q: %w",
			ErrQueryFailed, obj, query.String(), err)
	}

	return obj, nil
}

// GetByQuery returns zero or persistables by the provided query.
func (o Operator) GetByQuery(ctx context.Context, columns []string, clause string, args ...interface{}) ([]model.Persistable, error) {
	var (
		objs  = []model.Persistable{}
		query = strings.Builder{}
	)

	columns = append(columns, "id")
	fmt.Fprintf(&query, "SELECT %s FROM %s",
		selectSQL(o.Table, columns), o.Table)
	for _, join := range o.SelectJoin {
		query.WriteByte(' ')
		query.WriteString(join)
	}
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := o.DB.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return objs, fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	r, err := stmt.QueryContext(ctx, args...)
	if err != nil {
		switch {
		case errors.Is(err, sql.ErrNoRows):
			return objs, fmt.Errorf("select failed: %w", ErrNotFound)
		case err != nil:
			return nil, fmt.Errorf("%w: cannot select from %q: %w",
				ErrQueryFailed, query.String(), err)
		}
	}
	defer r.Close()

	for r.Next() {
		obj := o.Create()

		err := obj.UpdateFromScanner(r, columns)
		if err != nil {
			switch {
			case errors.Is(err, sql.ErrNoRows):
				return objs, fmt.Errorf("select failed: %w: Object %T using %q not found",
					ErrNotFound, obj, query.String())
			case err != nil:
				return nil, fmt.Errorf("%w: cannot select %T from %q: %w",
					ErrQueryFailed, obj, query.String(), err)
			}
		}
		objs = append(objs, obj)
	}

	return objs, nil
}

// InsertByQuery adds a persistable to the database, with an optional query, and
// returns the newly inserted id.
func (o Operator) InsertByQuery(ctx context.Context, obj model.Persistable, columns []string, clause string, args ...interface{}) (int64, error) {
	var query strings.Builder
	fmt.Fprintf(&query, "INSERT INTO %s (%s) VALUES (%s)",
		o.Table, insertSQL(columns), placeholderSQL(columns))
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := o.DB.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return 0, fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	fields, err := obj.ExtractFields(columns)
	if err != nil {
		return 0, fmt.Errorf("failed to get fields %q from %T: %w",
			columns, obj, err)
	}
	fields = append(fields, args...)

	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return 0, fmt.Errorf("%w: cannot insert object %T using %q: %w",
			ErrQueryFailed, obj, query.String(), err)
	}

	id, err := r.LastInsertId()
	if err != nil {
		return 0, fmt.Errorf("%w: failed to get ID after insert of %T using %q: %w",
			ErrQueryFailed, obj, query.String(), err)
	}

	return id, nil
}

// UpdateByQuery updates one model in the database, and returns the affected id.
func (o Operator) UpdateByQuery(ctx context.Context, obj model.Persistable, columns []string, clause string, args ...interface{}) (int64, error) {
	var query strings.Builder
	fmt.Fprintf(&query, "UPDATE %s SET %s",
		o.Table, updateSQL(columns))
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := o.DB.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return obj.GetID(), fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query.String(), err)
	}
	defer stmt.Close()

	fields, err := obj.ExtractFields(columns)
	if err != nil {
		return 0, fmt.Errorf("failed to get fields %q from %T: %w",
			columns, obj, err)
	}
	fields = append(fields, args...)

	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return obj.GetID(), fmt.Errorf("failed to update object %T using %q: %w",
			obj, query.String(), err)
	}

	rows, err := r.RowsAffected()
	if err != nil {
		return obj.GetID(), fmt.Errorf("failed to get results for update of %T using %q: %w",
			obj, query.String(), err)
	}

	switch rows {
	case 0:
		return obj.GetID(), fmt.Errorf("update failed: %v: Object %T not found",
			ErrNotFound, obj)
	case 1:
		// pass
	default:
		return obj.GetID(), fmt.Errorf("unexpected number of updates of %T using %q: %d",
			obj, query.String(), rows)
	}

	return obj.GetID(), nil
}

// Migrate updates the entire table if the object is a Migratable.
func (o Operator) Migrate(ctx context.Context) error {
	tx, err := o.DB.Pool.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("failed to start transaction: %w", err)
	}
	defer func() {
		_ = tx.Rollback()
	}()

	query := fmt.Sprintf("SELECT * FROM %s", o.Table)

	_select, err := tx.PrepareContext(ctx, query)
	if err != nil {
		return fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query, err)
	}
	defer _select.Close()

	r, err := _select.QueryContext(ctx)
	if err != nil {
		switch {
		case errors.Is(err, sql.ErrNoRows):
			return fmt.Errorf("select failed: %w", ErrNotFound)
		case err != nil:
			return fmt.Errorf("%w: cannot select from %q: %w",
				ErrQueryFailed, query, err)
		}
	}
	defer r.Close()

	columns, err := r.Columns()
	if err != nil {
		return fmt.Errorf("%w: cannot get columns from %q: %w",
			ErrQueryFailed, query, err)
	}

	updates := removeField(columns, "id")
	query = fmt.Sprintf("UPDATE %s SET %s WHERE id = ?",
		o.Table, updateSQL(updates))

	_update, err := tx.PrepareContext(ctx, query)
	if err != nil {
		return fmt.Errorf("%w: failed to prepare %q: %w",
			ErrQueryFailed, query, err)
	}
	defer _update.Close()

	for r.Next() {
		obj := o.Create()
		m, ok := obj.(model.Migrator)
		if !ok {
			return fmt.Errorf("object %T not Migratable", obj)
		}

		if err := m.Migrate(r, columns); err != nil {
			return fmt.Errorf("failed to migrate object %T: %v", obj, err)
		}

		fields, err := obj.ExtractFields(updates)
		if err != nil {
			return fmt.Errorf("failed to get fields %q from %T: %w",
				columns, obj, err)
		}
		fields = append(fields, obj.GetID())

		_, err = _update.ExecContext(ctx, fields...)
		if err != nil {
			return fmt.Errorf("failed to update object %T using %q: %w",
				obj, query, err)
		}
	}

	err = tx.Commit()
	if err != nil {
		return fmt.Errorf("failed to commit migration: %w", err)
	}

	return nil
}

func selectSQL(table string, fields []string) string {
	columns := make([]string, len(fields))
	for i, field := range fields {
		columns[i] = fmt.Sprintf("%s.%s", table, field)
	}
	return strings.Join(columns, ", ")
}

func insertSQL(fields []string) string {
	return strings.Join(fields, ", ")
}

func updateSQL(fields []string) string {
	columns := make([]string, len(fields))
	for i, field := range fields {
		columns[i] = fmt.Sprintf("%s = ?", field)
	}
	return strings.Join(columns, ", ")
}

func placeholderSQL(fields []string) string {
	return strings.Repeat(", ?", len(fields))[2:]
}

func removeField(fields []string, field string) []string {
	for i := range field {
		if fields[i] == field {
			without := []string{}
			without = append(without, fields[:i]...)
			without = append(without, fields[i+1:]...)
			return without
		}
	}

	return fields
}
