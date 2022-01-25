package database

import (
	"context"
	"database/sql"
	"fmt"
	"io"
	"strings"
)

func NewOperatorForPersistable(p Persistable) Operator {
	var columns = p.Columns()
	placeholders := strings.Repeat(", ?", len(columns))[2:]

	return Operator{
		persistable:  p,
		table:        p.Table(),
		placeholders: placeholders,
		columns:      strings.Join(columns, ", "),
		fields:       strings.Join(columns, " = ?, ") + " = ?",
	}
}

func (o Operator) GetByID(ctx context.Context, db Instance, id int64) (interface{}, error) {
	query := fmt.Sprintf("%s.id = ?", o.table)
	return o.GetOneByQuery(ctx, db, query, id)
}

func (o Operator) GetOneByQuery(ctx context.Context, db Instance, clause string, args ...interface{}) (interface{}, error) {
	var query strings.Builder
	fmt.Fprintf(&query, "SELECT `id`, %s FROM %s", o.columns, o.table)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		var obj interface{}
		return obj, fmt.Errorf("failed to prepare %q: %w", query.String(), err)
	}
	defer stmt.Close()

	r := stmt.QueryRowContext(ctx, args...)

	obj, err := o.persistable.NewFromRow(r)
	switch {
	case err == sql.ErrNoRows:
		return obj, fmt.Errorf("select failed: %v: Object %T not found", ErrNotFound, obj)
	case err != nil:
		return obj, fmt.Errorf("cannot create object %T from result: %w", obj, err)
	}

	return obj, nil
}

func (o Operator) GetByQuery(ctx context.Context, db Instance, clause string, args ...interface{}) ([]interface{}, error) {
	var (
		objs  []interface{}
		query strings.Builder
	)
	fmt.Fprintf(&query, "SELECT `id`, %s FROM %s", o.columns, o.table)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return objs, fmt.Errorf("failed to prepare %q: %w", query.String(), err)
	}
	defer stmt.Close()

	r, err := stmt.QueryContext(ctx, args...)
	if err != nil {
		switch {
		case err == sql.ErrNoRows:
			return objs, fmt.Errorf("select failed: %v", ErrNotFound)
		case err != nil:
			return objs, fmt.Errorf("failed to query objects: %w", err)
		}
	}
	defer r.Close()

	for r.Next() {
		obj, err := o.persistable.NewFromRow(r)
		if err != nil {
			switch {
			case err == sql.ErrNoRows:
				return objs, fmt.Errorf("select failed: %v: Object %T not found", ErrNotFound, obj)
			case err != nil:
				return objs, fmt.Errorf("cannot create object %T from result: %w", obj, err)
			}
		}
		objs = append(objs, obj)
	}

	return objs, nil
}

func (o Operator) InsertByQuery(ctx context.Context, db Instance, rdr io.Reader, clause string, args ...interface{}) (interface{}, error) {
	obj, err := o.persistable.NewFromReader(rdr)
	if err != nil {
		return obj, fmt.Errorf("failed to deserialize %T: %w", obj, err)
	}

	var query strings.Builder
	fmt.Fprintf(&query, "INSERT INTO %s (%s) VALUES (%s)", o.table, o.columns, o.placeholders)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return obj, fmt.Errorf("failed to prepare %q: %w", query.String(), err)
	}
	defer stmt.Close()

	fields := obj.GetFields()
	fields = append(fields, args...)

	fmt.Printf("%s (%q)\n", query.String(), fields)

	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return obj, fmt.Errorf("failed to insert object %T: %w", obj, err)
	}

	id, err := r.LastInsertId()
	if err != nil {
		return obj, fmt.Errorf("failed to get ID after insert of %T: %w", obj, err)
	}

	return o.GetByID(ctx, db, id)
}

func (o Operator) UpdateByQuery(ctx context.Context, db Instance, rdr io.Reader, clause string, args ...interface{}) (interface{}, error) {
	obj, err := o.GetOneByQuery(ctx, db, clause, args...)
	if err != nil {
		return obj, fmt.Errorf("failed to get original %T: %w", obj, err)
	}

	p, ok := obj.(Persistable)
	if !ok {
		return obj, fmt.Errorf("update object is not persistable %T", obj)
	}

	p, err = p.NewFromReader(rdr)
	if err != nil {
		return obj, fmt.Errorf("failed to deserialize %T: %w", obj, err)
	}

	var query strings.Builder
	fmt.Fprintf(&query, "UPDATE %s SET %s", o.table, o.fields)
	if clause != "" {
		fmt.Fprintf(&query, " WHERE %s", clause)
	}

	stmt, err := db.Pool.PrepareContext(ctx, query.String())
	if err != nil {
		return obj, fmt.Errorf("failed to prepare %q: %w", query.String(), err)
	}
	defer stmt.Close()

	fields := p.GetFields()
	fields = append(fields, args...)
	r, err := stmt.ExecContext(ctx, fields...)
	if err != nil {
		return obj, fmt.Errorf("failed to update object %T: %w", obj, err)
	}

	rows, err := r.RowsAffected()
	if err != nil {
		return obj, fmt.Errorf("failed to get results for update of %T: %w", obj, err)
	}

	switch rows {
	case 0:
		return obj, fmt.Errorf("update failed: %v: Object %T not found", ErrNotFound, obj)
	case 1:
		// pass
	default:
		return obj, fmt.Errorf("unexpected number of updates of %T: %d", obj, rows)
	}

	return o.GetOneByQuery(ctx, db, clause, args...)
}
