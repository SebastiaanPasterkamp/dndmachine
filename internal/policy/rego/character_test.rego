package authz.character

character := {
	"id": 1,
	"user_id": "alice",
	"party": {"members": [
		{"id": 1, "user_id": "alice"},
		{"id": 2, "user_id": "bob"},
	]},
}

test_get_anonymous_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
	}
		 with data.character as character
}

test_get_own_character_allowed {
	allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "alice"},
	}
		 with data.character as character
}

test_get_some_others_character_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "trudy"},
	}
		 with data.character as character
}

test_get_party_members_allowed {
	allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "bob"},
	}
		 with data.character as character
}

test_as_admin_allowed {
	allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "bob", "role": ["admin"]},
	}
		 with data.character as character
}
