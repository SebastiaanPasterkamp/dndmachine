package model

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"strings"

	"golang.org/x/crypto/bcrypt"
)

// User is the database.Persistable and api.JSONable implementation of a user
// model. The Password is protected by bcrypt, and can be used to verify
// credentials.
type User struct {
	UserAttributes
	UserRoles
	ID       int64  `json:"id"`
	Username string `json:"username"`
	Password string `json:"password,omitempty"`
	Email    string `json:"email,omitempty"`
	GoogleID string `json:"googleID,omitempty"`
}

// UserRoles are a collection of secondary fields stored in the role column of
// the user table. These attributes are only editable by admins.
type UserRoles struct {
	Role []string `json:"role,omitempty"`
}

// UserAttributes are a collection of non-primary fields stored in the config
// column of the user table.
type UserAttributes struct {
	DCI   string `json:"dci,omitempty"`
	Name  string `json:"name,omitempty"`
	Theme string `json:"theme,omitempty"`
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
		case "id":
			fields[i] = u.ID
		case "username":
			fields[i] = u.Username
		case "password":
			fields[i] = u.Password
		case "role":
			role, err := json.Marshal(u.UserRoles)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = role
		case "email":
			if u.Email != "" {
				fields[i] = u.Email
			} else {
				fields[i] = sql.NullString{}
			}
		case "google_id":
			if u.GoogleID != "" {
				fields[i] = u.GoogleID
			} else {
				fields[i] = sql.NullString{}
			}
		case "config":
			config, err := json.Marshal(u.UserAttributes)
			if err != nil {
				return fields, fmt.Errorf("failed to serialize %q: %w", column, err)
			}

			fields[i] = config
		default:
			return fields, fmt.Errorf("%w: %q", ErrUnknownColumn, column)
		}
	}

	return fields, nil
}

// UpdateFromScanner updates the user object with values contained in the
// database.Scanner.
func (u *User) UpdateFromScanner(row Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &u.ID
		case "username":
			fields[i] = &u.Username
		case "password":
			fields[i] = &u.Password
		case "role":
			role := []byte{}
			fields[i] = &role
		case "email":
			var value sql.NullString
			fields[i] = &value
		case "google_id":
			var value sql.NullString
			fields[i] = &value
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to scan fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "role":
			role := *fields[i].(*[]byte)
			if len(role) < 2 {
				continue
			}
			if err := json.Unmarshal(role, &u.UserRoles); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		case "email":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				u.Email = value.String
			}
		case "google_id":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				u.GoogleID = value.String
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &u.UserAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		}
	}

	return nil
}

// Migrate adjusts a User object to migrate fields from the UserAttributes
// struct to the main User struct.
func (u *User) Migrate(row Scanner, columns []string) error {
	fields := make([]interface{}, len(columns))
	for i, column := range columns {
		switch column {
		case "id":
			fields[i] = &u.ID
		case "username":
			fields[i] = &u.Username
		case "password":
			fields[i] = &u.Password
		case "role":
			role := []byte{}
			fields[i] = &role
		case "email":
			var value sql.NullString
			fields[i] = &value
		case "google_id":
			var value sql.NullString
			fields[i] = &value
		case "config":
			config := []byte{}
			fields[i] = &config
		default:
			return fmt.Errorf("%w: %q", ErrUnknownColumn, column)
		}
	}

	if err := row.Scan(fields...); err != nil {
		return fmt.Errorf("failed to migrate fields for %q: %w", columns, err)
	}

	for i, column := range columns {
		switch column {
		case "role":
			role := *fields[i].(*[]byte)
			if len(role) < 2 {
				continue
			}
			if err := json.Unmarshal(role, &u.UserRoles); err != nil {
				u.UserRoles.Role = strings.Split(string(role), ",")
				// don't try to unmarshal non-json for other fields
				continue
			}
			if err := json.Unmarshal(role, &u.UserAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
			if err := json.Unmarshal(role, &u); err != nil {
				return fmt.Errorf("failed to unmarshal %q: %w", column, err)
			}
		case "email":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				u.Email = value.String
			}
		case "google_id":
			value := fields[i].(*sql.NullString)
			if value.Valid {
				u.GoogleID = value.String
			}
		case "config":
			config := *fields[i].(*[]byte)
			if len(config) < 2 {
				continue
			}
			if err := json.Unmarshal(config, &u.UserAttributes); err != nil {
				return fmt.Errorf("failed to unmarshal %q for attributes: %w", column, err)
			}
			if err := json.Unmarshal(config, &u.UserRoles); err != nil {
				return fmt.Errorf("failed to unmarshal %q for roles: %w", column, err)
			}
			if err := json.Unmarshal(config, &u); err != nil {
				return fmt.Errorf("failed to unmarshal %q for object: %w", column, err)
			}
		}
	}

	return nil
}

// UnmarshalFromReader updates a user object from a JSON stream.
func (u *User) UnmarshalFromReader(r io.Reader) error {
	old := u.Password

	err := json.NewDecoder(r).Decode(u)
	if err != nil {
		return err
	}

	if u.Password == "" {
		u.Password = old
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
