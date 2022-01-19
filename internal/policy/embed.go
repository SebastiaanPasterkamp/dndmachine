package policy

import (
	"embed"
	"fmt"
	"path"
	"strings"

	"github.com/open-policy-agent/opa/ast"
)

const rulesDir = "rego"

//go:embed rego/*rego
var embedded embed.FS

func embeddedRules() (*ast.Compiler, error) {
	rules, err := embedded.ReadDir(rulesDir)
	if err != nil {
		return nil, fmt.Errorf("failed to read embedded rules: %w", err)
	}

	source := map[string]string{}
	for _, rule := range rules {
		if strings.Contains(rule.Name(), "_test.rego") {
			continue
		}

		data, err := embedded.ReadFile(path.Join(rulesDir, rule.Name()))
		if err != nil {
			return nil, fmt.Errorf("failed to read embedded rule %q: %w",
				rule.Name(), err)
		}

		source[rule.Name()] = string(data)
	}

	return ast.CompileModules(source)
}
