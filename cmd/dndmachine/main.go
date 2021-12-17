package main

import (
	"fmt"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
)

func main() {
	fmt.Printf("%s %s (%s-%s @ %s)\n",
		build.Name, build.Version, build.Branch, build.Commit, build.Timestamp)
}
