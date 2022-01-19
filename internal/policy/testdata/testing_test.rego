package testing

user := {"id": "alice"}

test_get_anonymous_denied {
	not allow with input as {
		"path": ["user", "alice"],
		"method": "GET",
	}
		 with data.user as user
}

test_get_own_user_allowed {
	allow with input as {
		"path": ["user", "alice"],
		"method": "GET",
		"user": {"id": "alice"},
	}
		 with data.user as user
}

test_get_some_others_user_denied {
	not allow with input as {
		"path": ["user", "alice"],
		"method": "GET",
		"user": {"id": "trudy"},
	}
		 with data.user as user
}
