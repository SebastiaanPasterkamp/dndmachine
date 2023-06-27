package authz.character_option

character_option := {{
	"id": 1,
	"uuid": "f00-b4r",
	"name": "example",
	"type": "character-description",
	"config": {},
}}

test_get_anonymous_denied {
	not allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "GET",
	}
		 with data.character_option as character_option
}

test_get_with_role_allowed {
	get_one = allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "GET",
		"user": {"id": "alice", "role": ["player"]},
	}
		 with data.character_option as character_option
}

test_get_as_admin_allowed {
	get_one = allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "GET",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character_option as character_option
}

test_list_with_role_allowed {
	get_list = allow with input as {
		"path": ["api", "character-option"],
		"method": "GET",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character_option as character_option
}

test_list_without_role_denied {
	not allow with input as {
		"path": ["api", "character-option"],
		"method": "GET",
		"user": {"id": "trudy", "role": []},
	}
		 with data.character_option as character_option
}

test_list_as_admin_allowed {
	get_list = allow with input as {
		"path": ["api", "character-option"],
		"method": "GET",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character_option as character_option
}

test_post_as_player_denied {
	not allow with input as {
		"path": ["api", "character-option"],
		"method": "POST",
		"user": {"id": "alice", "role": ["player"]},
	}
}

test_post_as_dm_denied {
	not allow with input as {
		"path": ["api", "character-option"],
		"method": "POST",
		"user": {"id": "dm", "role": ["dm"]},
	}
}

test_post_as_admin_allowed {
	allow with input as {
		"path": ["api", "character-option"],
		"method": "POST",
		"user": {"id": "admin", "role": ["admin"]},
	}
}

test_patch_as_dm_allowed {
	patch_one = allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "PATCH",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character_option as character_option
}

test_patch_as_player_denied {
	not allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "PATCH",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character_option as character_option
}

test_delete_as_player_denied {
	not allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "DELETE",
		"user": {"id": "alice", "role": ["player"]},
	}
		 with data.character_option as character_option
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "character-option", "1"],
		"method": "DELETE",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character_option as character_option
}
