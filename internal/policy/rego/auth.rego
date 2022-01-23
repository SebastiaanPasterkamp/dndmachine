package authz.auth

default allow = false

allow {
	input.path == ["auth", "login"]
	input.method == "POST"
	not input.user.id
}

allow {
	input.path == ["auth", "logout"]
	input.method == "GET"
	input.user.id
}

allow {
	input.path == ["auth", "current-user"]
	input.method == "GET"
	input.user.id
}
