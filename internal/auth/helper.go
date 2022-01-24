package auth

import (
	"net/http"
	"regexp"
	"strings"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

var cleanURL = regexp.MustCompile(`[^a-zA-Z0-9/_-]+`)

func getInput(r *http.Request) map[string]interface{} {
	user, _ := r.Context().Value(CurrentUser).(*model.User)
	url := strings.Trim(r.URL.Path, "/")
	url = cleanURL.ReplaceAllString(url, "_")
	path := strings.Split(url, "/")

	return map[string]interface{}{
		"path":   path,
		"method": r.Method,
		"user":   user,
	}
}
