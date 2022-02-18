package api_test

import (
	"fmt"
	"math/rand"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"github.com/SebastiaanPasterkamp/dndmachine/internal/storage"
)

func mockDatabase() (database.Instance, error) {
	dsn := fmt.Sprintf("sqlite://file:test-%d.db?mode=memory&cache=shared", rand.Int())

	db, err := database.Connect(database.Configuration{
		DSN:          dsn,
		MaxOpenConns: 1,
		MaxIdleConns: 1,
	})
	if err != nil {
		return db, err
	}

	s := storage.Instance{
		Path:    "../../schema",
		Upgrade: &storage.CmdUpgrade{},
	}

	err = s.Command(db)

	return db, err
}
