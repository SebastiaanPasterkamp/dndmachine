package cache

import (
	"context"
	"time"
)

type Memory struct {
	db map[interface{}]interface{}
}

func NewMemory(_ *InMemorySettings) *Memory {
	return &Memory{
		db: map[interface{}]interface{}{},
	}
}

func (m *Memory) Set(_ context.Context, key, value interface{}, _ time.Duration) error {
	m.db[key] = value
	return nil
}

func (m *Memory) Get(_ context.Context, key interface{}) (interface{}, error) {
	value, ok := m.db[key]
	if !ok {
		return nil, ErrNotFound
	}

	return value, nil
}

func (m *Memory) Del(_ context.Context, key interface{}) error {
	delete(m.db, key)

	return nil
}
