package storage

import (
	"bufio"
	"context"
	"database/sql"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/coreos/go-semver/semver"
)

type SchemaChange struct {
	Version     semver.Version
	Path        string
	Description string
}

func NewSchemaChange(path string) (SchemaChange, error) {
	reVersion := regexp.MustCompile(`\b(\d+\.\d+\.\d+)\b`)

	schema := SchemaChange{
		Path: path,
	}

	v := reVersion.Find([]byte(path))
	version, err := semver.NewVersion(string(v))
	if err != nil {
		return schema, fmt.Errorf("%w of %q (%q): %s",
			ErrInvalidVersion, path, v, err)
	}
	schema.Version = *version

	r, err := schema.Reader()
	if err != nil {
		return schema, fmt.Errorf("%w from %q: %s",
			ErrMissingSchemaDescription, path, err)
	}

	if scanner := bufio.NewScanner(r); scanner.Scan() {
		if d := scanner.Text(); len(d) > 3 {
			schema.Description = d[3:]
		}
	}

	if schema.Description == "" {
		return schema, fmt.Errorf("%w from %q",
			ErrMissingSchemaDescription, path)
	}

	return schema, nil
}

func (s *SchemaChange) Reader() (io.Reader, error) {
	return os.Open(s.Path)
}

func (s SchemaChange) ApplicationDate(db database.Instance) (time.Time, error) {
	ctx := context.Background()

	tx, err := db.Pool.BeginTx(ctx, &sql.TxOptions{
		ReadOnly: true,
	})
	if err != nil {
		return time.Time{}, err
	}
	defer func() {
		_ = tx.Rollback()
	}()

	return s.applicationDate(tx)
}

func (s SchemaChange) applicationDate(db *sql.Tx) (time.Time, error) {
	row := db.QueryRow(getApplicationDate, s.Version.String())

	var timestamp time.Time
	if err := row.Scan(&timestamp); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			// Schema not applied
			return time.Time{}, ErrNotApplied
		}

		return time.Time{}, fmt.Errorf("failed to determine application date: %w", err)
	}

	return timestamp, nil
}

func (s *SchemaChange) Register(db database.Instance) (time.Time, error) {
	ctx := context.Background()

	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return time.Time{}, err
	}
	defer func() {
		_ = tx.Rollback()
	}()

	dt, err := s.register(tx)
	if err != nil {
		return time.Time{}, err
	}

	err = tx.Commit()
	if err != nil {
		return dt, fmt.Errorf("failed to register schema change: %w", err)
	}

	return dt, nil
}

func (s *SchemaChange) register(db *sql.Tx) (time.Time, error) {
	_, err := db.Exec(registerChange, s.Version.String(), s.Path, s.Description, time.Now())
	if err != nil {
		return time.Time{}, fmt.Errorf("error preparing statement %q: %w",
			registerChange, err)
	}

	return s.applicationDate(db)
}

func Initialize(db database.Instance) error {
	ctx := context.Background()

	tx, err := db.Pool.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer func() {
		_ = tx.Rollback()
	}()

	err = initialize(tx)
	if err != nil {
		return fmt.Errorf("failed to initialize database: %w", err)
	}

	err = tx.Commit()
	if err != nil {
		return fmt.Errorf("failed to commit initialized database: %w", err)
	}

	return nil
}

func initialize(db *sql.Tx) error {
	_, err := db.Exec(createSchemasTable)
	if err == nil {
		return nil
	}

	if strings.Contains(err.Error(), "table schema already exists") {
		return nil
	}

	return fmt.Errorf("failed to create schema versioning table: %w", err)
}

func ListSchemaDir(dir string) ([]*SchemaChange, error) {
	schemas := []*SchemaChange{}

	files, err := ioutil.ReadDir(dir)
	if err != nil {
		return schemas, fmt.Errorf("failed to read dir %q: %w", dir, err)
	}

	for _, file := range files {
		if !strings.HasSuffix(file.Name(), ".sql") {
			continue
		}

		schema, err := NewSchemaChange(filepath.Join(dir, file.Name()))
		if err != nil {
			return schemas, fmt.Errorf("failed to load schema %q: %w",
				file.Name(), err)
		}

		schemas = append(schemas, &schema)
	}

	sort.SliceStable(schemas, func(i, j int) bool {
		return schemas[i].Version.LessThan(schemas[j].Version)
	})

	return schemas, nil
}
