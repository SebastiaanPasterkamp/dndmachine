package database

import (
	"database/sql"
	"fmt"
	"strings"

	// Import the MySQL database driver. It is automatically registered.
	_ "github.com/go-sql-driver/mysql"
	"modernc.org/sqlite"
)

func Connect(cfg Configuration) (Instance, error) {
	db := Instance{
		Pool: nil,
		cfg:  cfg,
	}

	args := strings.Split(cfg.DSN, "://")
	if len(args) != 2 {
		return db, fmt.Errorf("%w: %q", ErrMalformedDNS, cfg.DSN)
	}

	if err := register(args[0]); err != nil {
		return db, fmt.Errorf("unable to connect to database: %w", err)
	}

	pool, err := sql.Open(args[0], args[1])
	if err != nil {
		return db, fmt.Errorf("unable to connect to database: %w", err)
	}

	pool.SetConnMaxLifetime(cfg.ConnMaxLifetime)
	pool.SetMaxIdleConns(cfg.MaxIdleConns)
	pool.SetMaxOpenConns(cfg.MaxOpenConns)
	db.Pool = pool

	return db, nil
}

func (i *Instance) IsConnected() bool {
	if i.Pool == nil {
		return false
	}

	if err := i.Pool.Ping(); err != nil {
		return false
	}

	return true
}

func (i *Instance) Close() error {
	if i.Pool == nil {
		return nil
	}

	err := i.Pool.Close()
	i.Pool = nil

	if err != nil {
		return fmt.Errorf("problem closing DB connection: %w", err)
	}

	return nil
}

func register(name string) error {
	for _, registered := range sql.Drivers() {
		if name == registered {
			return nil
		}
	}

	switch name {
	case "sqlite":
		sql.Register(name, &sqlite.Driver{})
	case "sqlite3":
		sql.Register(name, &sqlite.Driver{})
	default:
		return fmt.Errorf("%w: %q", ErrUnsupportedDriver, name)
	}

	return nil
}
