package policy

import (
	"encoding/json"
	"fmt"
	"strings"

	"github.com/open-policy-agent/opa/ast"
)

func queriesToSQL(modules []*ast.Module) (PartialSQL, error) {
	var (
		fields  = []string{}
		clauses = []string{}
		values  = []interface{}{}
	)

	for _, module := range modules {
		for _, rule := range module.Rules {
			sub, err := expressionsToSQL(rule.Body)
			if err != nil {
				return PartialSQL{}, err
			}
			if sub.Clause != "" {
				fields = append(fields, sub.Fields...)
				clauses = append(clauses, sub.Clause)
				values = append(values, sub.Values...)
			}
		}
	}

	return PartialSQL{
		Fields: fields,
		Clause: strings.Join(clauses, " OR "),
		Values: values,
	}, nil
}

var exprToOperator = map[string]string{
	"eq":       "=",
	"equal":    "=",
	"lt":       "<",
	"gt":       ">",
	"lte":      "<=",
	"gte":      ">=",
	"neq":      "!=",
	"contains": "CONTAINS",
	"re_match": "REGEXP",
}

func expressionsToSQL(expressions []*ast.Expr) (PartialSQL, error) {
	var (
		clauses = []string{}
		values  = []interface{}{}
	)

	for _, expr := range expressions {
		if !expr.IsCall() {
			continue
		}

		tableColumn, value, err := termsToTableColumnAndValue(expr.Operands())
		if err != nil {
			return PartialSQL{}, err
		}

		operator, ok := exprToOperator[expr.Operator().String()]
		if !ok {
			return PartialSQL{}, fmt.Errorf("%w: %q", ErrOperatorNotSupported, expr.Operator().String())
		}

		clauses = append(clauses, fmt.Sprintf("%s %s ?", tableColumn, operator))
		values = append(values, value)
	}

	sql := PartialSQL{}
	switch len(clauses) {
	case 0:
		// unchanged
	case 1:
		sql.Clause = clauses[0]
		sql.Values = values
	default:
		sql.Clause = "(" + strings.Join(clauses, " AND ") + ")"
		sql.Values = values
	}

	return sql, nil
}

func termsToTableColumnAndValue(terms []*ast.Term) (tableColumn string, value interface{}, err error) {
	if len(terms) != 2 {
		err = fmt.Errorf("invalid expression: too many arguments")
		return
	}

	for _, term := range terms {
		if ast.IsConstant(term.Value) {
			if value, err = ast.JSON(term.Value); err != nil {
				err = fmt.Errorf("error converting term to JSON: %w", err)
				return
			}

			if n, ok := value.(json.Number); ok {
				if i, err := n.Int64(); err == nil {
					value = i
				} else if f, err := n.Float64(); err == nil {
					value = f
				} else {
					panic("Whoops")
				}
			}

			continue
		}

		tokens := []string{}
		for _, token := range strings.Split(term.String(), ".") {
			tokens = append(tokens, strings.Split(token, "[")[0])
		}

		l := len(tokens)
		tableColumn = tokens[l-2] + "." + tokens[l-1]
	}

	return
}
