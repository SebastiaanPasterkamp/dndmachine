package config

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
	"github.com/alexflint/go-arg"
)

// Initialize updates the Arguments structure using command line options,
// environment variables, the contents of the --config-path, and finally any of
// the default values - in order or priority.
func Initialize(flags []string) (Arguments, error) {
	var (
		args = Arguments{}
		err  error
		p    *arg.Parser
	)

	cfg := arg.Config{
		Program: flags[0],
	}
	if p, err = arg.NewParser(cfg, &args); err != nil {
		return args, fmt.Errorf("failed to parse CLI arguments: %w", err)
	}

	if err = p.Parse(flags[1:]); err != nil {
		switch {
		case errors.Is(err, arg.ErrHelp):
			p.WriteHelp(os.Stdout)

			return args, nil
		case errors.Is(err, arg.ErrVersion):
			log.Println(build.Version)

			return args, nil
		default:
			p.WriteUsage(os.Stderr)
		}

		return args, fmt.Errorf("error parsing arguments: %w", err)
	}

	if p.Subcommand() == nil {
		return args, ErrMissingSubcommand
	}

	if args.Common.ConfigPath == "" {
		return args, nil
	}

	fh, err := os.Open(args.Common.ConfigPath)
	if err != nil {
		return args, fmt.Errorf("failed to read config file %q: %w",
			args.Common.ConfigPath, err)
	}
	defer fh.Close()

	if err := json.NewDecoder(fh).Decode(&args); err != nil {
		return args, fmt.Errorf("failed to parse config file %q: %w",
			args.Common.ConfigPath, err)
	}

	cfg = arg.Config{
		Program:        flags[0],
		IgnoreDefaults: true,
		IgnoreEnv:      false,
	}
	if p, err = arg.NewParser(cfg, &args); err != nil {
		return args, fmt.Errorf("failed to create CLI argument parser: %w", err)
	}

	if err = p.Parse(flags[1:]); err != nil {
		return args, fmt.Errorf("failed to parse CLI arguments: %w", err)
	}

	return args, nil
}
