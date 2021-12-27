package graceful

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"
)

func Shutdown(ctx context.Context) context.Context {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, os.Signal(syscall.SIGTERM), os.Signal(syscall.SIGHUP))

	grace, cancel := context.WithCancel(ctx)

	go func() {
		sig := <-c
		log.Printf("system call: %+v", sig)
		cancel()
	}()

	return grace
}
