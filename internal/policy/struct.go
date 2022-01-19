package policy

import (
	"sync"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
)

type Configuration struct {
	Path string `json:"regoSourceDirectory" arg:"--rego-source-dir" help:"Alternative source directory for rego rules. Leave empty to use embedded rules."`
}

type Enforcer struct {
	mu    sync.Mutex
	cache map[interface{}]*rego.Rego
	rules *ast.Compiler
}
