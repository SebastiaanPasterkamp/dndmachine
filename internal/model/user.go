package model

import (
	"encoding/json"
	"io"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	UserAttributes
	ID       int64    `json:"id"`
	Username string   `json:"username"`
	Password string   `json:"password,omitempty"`
	Role     []string `json:"role"`
	Email    string   `json:"email,omitempty"`
	GoogleID string   `json:"googleID,omitempty"`
}

type UserAttributes struct {
	DCI  string `json:"dci,omitempty"`
	Name string `json:"name,omitempty"`
}

func (User) Table() string {
	return `user`
}

func (User) Columns() []string {
	return []string{"username", "password", "role", "email", "google_id", "config"}
}

func (u User) NewFromReader(r io.Reader) (database.Persistable, error) {
	var n User
	err := json.NewDecoder(r).Decode(&n)
	if err != nil {
		return n, err
	}

	switch n.Password {
	case "":
		n.Password = u.Password
	default:
		pwd, err := bcrypt.GenerateFromPassword([]byte(n.Password), 0)
		if err != nil {
			return n, err
		}

		n.Password = string(pwd)
	}

	return n, err
}

func (u User) GetFields() []interface{} {
	config, _ := json.Marshal(u.UserAttributes)
	return []interface{}{
		u.Username,
		u.Password,
		u.Email,
		string(config),
	}
}

func (User) NewFromRow(row database.Scanner) (database.Persistable, error) {
	var (
		u      User
		config string
	)

	if err := row.Scan(&u.ID, &u.Username, &u.Password, &u.Email, &config); err != nil {
		return u, err
	}

	if err := json.Unmarshal([]byte(config), &u.UserAttributes); err != nil {
		return u, err
	}

	return u, nil
}

var UserDB = database.NewOperatorForPersistable(User{})
