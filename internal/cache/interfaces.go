package cache

import (
	"context"
	"time"
)

type Repository interface {
	Set(ctx context.Context, key, value interface{}, TTL time.Duration) error
	Get(ctx context.Context, key interface{}) (interface{}, error)
	Del(ctx context.Context, key interface{}) error
}
