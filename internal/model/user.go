package model

import (
	"encoding/json"
	"fmt"
	"io"
	"strings"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/database"
	"golang.org/x/crypto/bcrypt"
)

// User is the database.Persistable and api.JSONable implementation of a user
// model. The Password is protected by bcrypt, and can be used to verify
// credentials.
type User struct {
	UserAttributes
	ID       int64    `json:"id"`
	Username string   `json:"username"`
	Password string   `json:"password,omitempty"`
	Role     []string `json:"role"`
	Email    string   `json:"email,omitempty"`
	GoogleID string   `json:"googleID,omitempty"`
}

// UserAttributes are a collection of non-primary fields stored in the config
// column of the user table.
type UserAttributes struct {
	DCI  string `json:"dci,omitempty"`
	Name string `json:"name,omitempty"`
}

// VerifyCredentials verifies the provided password against the encrypted user
// password.
func (u User) VerifyCredentials(password string) error {
	return bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password))
}

// GetID returns the primary key of the database.Persistable.
func (u User) GetID() int64 {
	return u.ID
}

// ExtractFields returns user attributes in order specified by the columns
// argument.
func (u User) ExtractFields(columns []string) ([]interface{}, error) {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "username":
			fields[i] = u.Username
		case "password":
			fields[i] = u.Password
		case "role":
			fields[i] = strings.Join(u.Role, ",")
		case "email":
			fields[i] = u.Email
		case "google_id":
			fields[i] = u.GoogleID
		case "config":
			config, err := json.Marshal(u.UserAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UserDB is a database Operator to store / retrieve user models.
var UserDB = database.Operator{
	Table: "user",
	NewFromRow: func(row database.Scanner, columns []string) (database.Persistable, error) {
		u := User{}
		fields := make([]interface{}, len(columns)+1)
		fields[len(columns)] = &u.ID

		for i, column := range columns {
			switch column {
			case "username":
				fields[i] = &u.Username
			case "password":
				fields[i] = &u.Password
			case "role":
				role := ""
				fields[i] = &role
			case "email":
				fields[i] = &u.Email
			case "google_id":
				fields[i] = &u.GoogleID
			case "config":
				config := []byte{}
				fields[i] = &config
			default:
				return nil, fmt.Errorf("%w: %q", database.ErrUnknownColumn, column)
			}
		}

		if err := row.Scan(fields...); err != nil {
			return nil, err
		}

		for i, column := range columns {
			switch column {
			case "role":
				u.Role = strings.Split(*fields[i].(*string), ",")
			case "config":
				if err := json.Unmarshal(*fields[i].(*[]byte), &u.UserAttributes); err != nil {
					return nil, err
				}
			}
		}

		return &u, nil
	},
}

// UserFromReader returns a user model created from a json stream.
func UserFromReader(r io.Reader) (database.Persistable, error) {
	u := User{}
	err := u.UnmarshalFromReader(r)
	return u, err
}

// UnmarshalFromReader updates a user object from a JSON stream.
func (u *User) UnmarshalFromReader(r io.Reader) error {
	old := u.Password

	err := json.NewDecoder(r).Decode(u)
	if err != nil {
		return err
	}

	if u.Password != old {
		pwd, err := bcrypt.GenerateFromPassword([]byte(u.Password), 0)
		if err != nil {
			return err
		}

		u.Password = string(pwd)
	}

	return nil
}

// MarshalToWriter writes a user object as a JSON stream.
func (u *User) MarshalToWriter(w io.Writer) error {
	return json.NewEncoder(w).Encode(u)
}
