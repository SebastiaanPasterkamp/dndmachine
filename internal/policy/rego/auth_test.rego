package authz.auth

test_post_login_allowed {
	allow with input as {
		"path": ["auth", "login"],
		"method": "POST",
	}
}

test_post_existing_login_denied {
	not allow with input as {
		"path": ["auth", "login"],
		"method": "POST",
		"user": {"id": 1},
	}
}

test_get_login_denied {
	not allow with input as {
		"path": ["auth", "login"],
		"method": "GET",
		"user": null,
	}
}

test_post_logout_allowed {
	allow with input as {
		"path": ["auth", "logout"],
		"method": "GET",
		"user": {"id": 1},
	}
}

test_post_anonymous_logout_denied {
	not allow with input as {
		"path": ["auth", "logout"],
		"method": "GET",
	}
}

test_get_current_user_allowed {
	allow with input as {
		"path": ["auth", "current-user"],
		"method": "GET",
		"user": {"id": 1},
	}
}

test_get_anonymous_current_user_denied {
	not allow with input as {
		"path": ["auth", "logout"],
		"method": "GET",
	}
}
