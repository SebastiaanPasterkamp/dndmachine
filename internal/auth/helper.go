package auth

import (
	"net/http"
	"strings"

	"github.com/SebastiaanPasterkamp/dndmachine/internal/model"
)

func getInput(r *http.Request) map[string]interface{} {
	user, _ := r.Context().Value(CurrentUser).(*model.User)
	path := strings.Split(strings.Trim(r.URL.Path, "/"), "/")

	return map[string]interface{}{
		"path":   path,
		"method": r.Method,
		"user":   user,
	}
}
