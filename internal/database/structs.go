package database

import (
	"database/sql"
	"time"
)

type Configuration struct {
	// DSN is the URI of the database to connect to.
	DSN string `json:"dsn" arg:"--database,env:DNDMACHINE_DSN" default:"sqlite://machine.db" placeholder:"DSN" help:"The database URI to connect to."`
	// ConnMaxLifetime is the maximum amount of time a connection may be reused.
	ConnMaxLifetime time.Duration `json:"connMaxLifetime" arg:"--conn-max-lifetime" default:"15m" placeholder:"duration" help:"The maximum amount of time a connection may be reused."`
	// MaxIdleConns is the maximum amount of idle connections in the pool.
	MaxIdleConns int `json:"maxIdleConns" arg:"--max-idle-conns" default:"3" placeholder:"#" help:"The maximum amount of idle connections in the pool."`
	// MaxOpenConns is the maximum amount of open connections to the database.
	MaxOpenConns int `json:"maxOpenConns" arg:"--max-open-conns" default:"3" placeholder:"#" help:"The maximum amount of open connections to the database."`
	// PingTimeout is the maximum time a ping will wait for a response.
	PingTimeout time.Duration `json:"pingTimeout" arg:"--ping-timeout" default:"3s" placeholder:"duration" help:"The maximum time a ping will wait for a response."`
}

type Instance struct {
	// Pool is the database connection pool.
	Pool *sql.DB
	// cfg is the configuration used to create the connection pool
	cfg Configuration
}

type Operator struct {
	table     string
	baseQuery string
	scan      func(row Scanner) (interface{}, error)
}
