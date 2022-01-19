package policy

import (
	"fmt"
	"io/ioutil"
	"path"
	"strings"

	"github.com/open-policy-agent/opa/ast"
)

func loadDir(dir string) (*ast.Compiler, error) {
	rules, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil, fmt.Errorf("failed to read rules directory %q: %w", dir, err)
	}

	source := map[string]string{}
	for _, rule := range rules {
		if strings.Contains(rule.Name(), "_test.rego") {
			continue
		}

		data, err := ioutil.ReadFile(path.Join(dir, rule.Name()))
		if err != nil {
			return nil, fmt.Errorf("failed to read rule from file %q: %w",
				rule.Name(), err)
		}

		source[rule.Name()] = string(data)
	}

	return ast.CompileModules(source)
}
