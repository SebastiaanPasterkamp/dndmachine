package service

import (
	"context"
	"net/http"
	"sync"
	"time"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/cache"
)

// Instance is the collection of parameters for running the D&D service.
type Instance struct {
	mu            sync.Mutex
	srv           *http.Server
	shutdownStart *context.CancelFunc
	shutdownAck   chan (interface{})
	url           string

	// Port is the port number where the service will listen on.
	Port string `json:"port" arg:"--port,env:DNDMACHINE_PORT" default:"8080" help:"Port to listen on."`

	// RequestTimeout is the maximum duration of a request.
	RequestTimeout time.Duration `json:"requestTimeout" arg:"--request-timeout" placeholder:"duration" default:"30s" help:"The maximum duration of a request."`
	// ReadTimeout is the maximum duration for reading the entire request, including the body.
	ReadTimeout time.Duration `json:"readTimeout" arg:"--read-timeout" placeholder:"duration" default:"5s" help:"The maximum duration for reading the entire request, including the body."`
	// ReadHeaderTimeout is the amount of time allowed to read request headers.
	ReadHeaderTimeout time.Duration `json:"readHeaderTimeout" arg:"--read-header-timeout" placeholder:"duration" default:"5s" help:"The amount of time allowed to read request headers."`
	// WriteTimeout is the maximum duration before timing out writes of the response.
	WriteTimeout time.Duration `json:"writeTimeout" arg:"--write-timeout" placeholder:"duration" default:"5s" help:"The maximum duration before timing out writes of the response."`
	// IdleTimetout is the maximum amount of time to wait for the next request when keep-alive is enabled.
	IdleTimetout time.Duration `json:"idleTimeout" arg:"--idle-timeout" placeholder:"duration" default:"1m" help:"The maximum amount of time to wait for the next request when keep-alive is enabled."`
	// MaxShutdownDelay is the maximum time a shutdown is delayed to allow for a
	// readiness probe to occur. During this time all readiness probes will be
	// unsuccessful, so no more traffic is sent to the terminating service.
	MaxShutdownDelay time.Duration `json:"maxShutdownDelay" arg:"--max-shutdown-delay" placeholder:"duration" default:"0s" help:"The maximum time a shutdown is delayed to allow for a readiness probe to occur. During this time all readiness probes will be unsuccessful, so no more traffic is sent to the terminating service."`
	// ShutdownDeadline is the maximum grace time for a shutdown.
	ShutdownDeadline time.Duration `json:"shutdownDeadline" arg:"--shutdown-deadline" placeholder:"duration" default:"5s" help:"The maximum grace time for a shutdown."`

	// Cache is the configuration for a cache implementation.
	Cache cache.Configuration `json:"cache" arg:"-"`
}
