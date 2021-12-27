package service

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/build"
)

type version struct {
	Name      string `json:"name"`
	Version   string `json:"version"`
	Commit    string `json:"commit"`
	Branch    string `json:"branch"`
	Timestamp string `json:"timestamp"`
}

func HandleVersion() http.HandlerFunc {
	b, _ := json.Marshal(version{
		Name:      build.Name,
		Version:   build.Version,
		Commit:    build.Commit,
		Branch:    build.Branch,
		Timestamp: build.Timestamp,
	})

	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		_, err := w.Write(b)
		if err != nil {
			log.Printf("writing version failed: %v", err)
		}
	}
}
