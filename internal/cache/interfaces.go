package cache

import (
	"context"
	"time"
)

type Repository interface {
	Set(ctx context.Context, key string, value interface{}, TTL time.Duration) error
	Get(ctx context.Context, key string, value interface{}) error
	Del(ctx context.Context, key string) error
}
