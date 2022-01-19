package policy

import (
	"context"
	"fmt"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
)

func NewEnforcer(cfg Configuration) (*Enforcer, error) {
	var (
		rules *ast.Compiler
		err   error
	)

	switch {
	case cfg.Path != "":
		rules, err = loadDir(cfg.Path)
	default:
		rules, err = embeddedRules()
	}
	if err != nil {
		return nil, fmt.Errorf("failed to load policy rules: %v", err)
	}

	return &Enforcer{
		cache: map[interface{}]*rego.Rego{},
		rules: rules,
	}, nil
}

func (e *Enforcer) getRegoEngine(query string, unknowns ...string) *rego.Rego {
	key := fmt.Sprintf("%q: {%q}", query, unknowns)
	e.mu.Lock()
	defer e.mu.Unlock()

	query = "data." + query

	if cache, ok := e.cache[key]; ok {
		return cache
	}

	if len(unknowns) == 0 {
		e.cache[key] = rego.New(
			rego.Compiler(e.rules),
			rego.Query(query),
		)

		return e.cache[key]
	}

	data := make([]string, len(unknowns))
	for i, unknown := range unknowns {
		data[i] = "data." + unknown
	}

	e.cache[key] = rego.New(
		rego.Compiler(e.rules),
		rego.Query(query),
		rego.Unknowns(data),
	)

	return e.cache[key]
}

func (e *Enforcer) Allow(ctx context.Context, query string, input map[string]interface{}) (bool, error) {
	eng := e.getRegoEngine(query)

	e.mu.Lock()
	pq, err := eng.PrepareForEval(ctx)
	e.mu.Unlock()

	if err != nil {
		return false, fmt.Errorf("failed to prepare opa query: %w", err)
	}

	rs, err := pq.Eval(ctx, rego.EvalInput(input))
	if err != nil {
		return false, fmt.Errorf("failed to evaluate opa query: %w", err)
	}

	return rs.Allowed(), nil
}

func (e *Enforcer) Partial(ctx context.Context, query string, unknowns []string, input map[string]interface{}) (bool, string, []interface{}, error) {
	if len(unknowns) == 0 {
		return false, "", []interface{}{}, fmt.Errorf("cannot create partial query without unknowns")
	}

	eng := e.getRegoEngine(query, unknowns...)

	e.mu.Lock()
	ppq, err := eng.PrepareForPartial(ctx)
	e.mu.Unlock()

	if err != nil {
		return false, "", []interface{}{}, fmt.Errorf("failed to prepare partial opa query: %w", err)
	}

	pq, err := ppq.Partial(ctx, rego.EvalInput(input))
	if err != nil {
		return false, "", []interface{}{}, fmt.Errorf("failed to evaluate partial opa query: %w", err)
	}

	if len(pq.Support) == 0 {
		return false, "false", []interface{}{}, nil
	}

	for _, module := range pq.Support {
		if len(module.Rules) == 1 && module.Rules[0].Default {
			return module.Rules[0].Head.Value.Value.String() == "true", "", []interface{}{}, nil
		}
	}

	clause, values, err := queriesToSQL(pq.Support)

	return true, clause, values, err
}
