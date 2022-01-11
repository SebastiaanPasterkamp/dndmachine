package database

import (
	"context"
	"database/sql"
	"fmt"
)

func NewOperator(table, baseQuery string, scan func(row *sql.Row) (interface{}, error)) Operator {
	return Operator{
		table:     table,
		baseQuery: baseQuery,
		scan:      scan,
	}
}

func (o Operator) GetByID(ctx context.Context, db Instance, id int) (interface{}, error) {
	query := fmt.Sprintf("%s.id = ?", o.table)
	return o.GetByQuery(ctx, db, query, id)
}

func (o Operator) GetByQuery(ctx context.Context, db Instance, clause string, args ...interface{}) (interface{}, error) {
	query := fmt.Sprintf("%s WHERE %s", o.baseQuery, clause)

	stmt, err := db.Pool.PrepareContext(ctx, query)
	if err != nil {
		var obj interface{}
		return obj, fmt.Errorf("failed to prepare %q: %v", query, err)
	}
	defer stmt.Close()

	r := stmt.QueryRowContext(ctx, args...)
	obj, err := o.scan(r)

	switch {
	case err == sql.ErrNoRows:
		return obj, fmt.Errorf("%v: Object %T not found", ErrNotFound, obj)
	case err != nil:
		return obj, fmt.Errorf("cannot create object %T from result: %v", obj, err)
	}

	return obj, nil
}
