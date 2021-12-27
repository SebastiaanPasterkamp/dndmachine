package storage_test

import (
	"fmt"
	"math/rand"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

func mockDatabase() (database.Instance, error) {
	dsn := fmt.Sprintf("sqlite://file:test-%d.db?mode=memory&cache=shared", rand.Int())

	return database.Connect(database.Configuration{
		DSN:          dsn,
		MaxOpenConns: 1,
		MaxIdleConns: 1,
	})
}
