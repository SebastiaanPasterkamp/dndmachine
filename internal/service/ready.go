package service

import (
	"context"
	"net/http"
	"sync"
)

func HandleReady(ctx context.Context, c chan (interface{})) http.HandlerFunc {
	var once sync.Once

	return func(w http.ResponseWriter, r *http.Request) {
		select {
		case <-ctx.Done():
			w.WriteHeader(http.StatusServiceUnavailable)
			once.Do(func() {
				close(c)
			})
		default:
			w.WriteHeader(http.StatusOK)
		}
	}
}
