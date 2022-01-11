package model

import (
	"database/sql"
	"encoding/json"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
)

type User struct {
	UserAttributes
	ID       int64  `json:"id"`
	Username string `json:"username"`
	Password string `json:"-"`
	Email    string `json:"email,omitempty"`
}

type UserAttributes struct {
	Role []string `json:"role"`
}

var UserDB = database.NewOperator(
	`user`,
	`SELECT
		id, username, password, config
	FROM user
	`,
	func(row *sql.Row) (interface{}, error) {
		var (
			u      User
			config string
		)

		if err := row.Scan(&u.ID, &u.Username, &u.Password, &config); err != nil {
			return u, err
		}

		if err := json.Unmarshal([]byte(config), &u.UserAttributes); err != nil {
			return u, err
		}

		return u, nil
	},
)
