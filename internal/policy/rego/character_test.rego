package authz.character

character := {
	{
		"id": 1,
		"user_id": "alice",
		"party": {"member": [
			{"id": 1, "user_id": "alice"},
			{"id": 2, "user_id": "bob"},
		]},
	},
	{
		"id": 2,
		"user_id": "bob",
		"party": {"member": [
			{"id": 1, "user_id": "alice"},
			{"id": 2, "user_id": "bob"},
		]},
	},
}

test_get_anonymous_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
	}
		 with data.character as character
}

test_get_own_character_allowed {
	get_one = allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "alice", "role": ["player"]},
	}
		 with data.character as character
}

test_get_some_others_character_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "trudy", "role": ["player"]},
	}
		 with data.character as character
}

test_get_party_members_allowed {
	get_one = allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character as character
}

test_get_as_admin_allowed {
	get_one = allow with input as {
		"path": ["api", "character", "1"],
		"method": "GET",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character as character
}

test_list_as_party_member_allowed {
	get_list = allow with input as {
		"path": ["api", "character"],
		"method": "GET",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character as character
}

test_list_as_non_party_member_denied {
	not allow with input as {
		"path": ["api", "character"],
		"method": "GET",
		"user": {"id": "trudy", "role": ["player"]},
	}
		 with data.character as character
}

test_list_as_admin_allowed {
	get_list = allow with input as {
		"path": ["api", "character"],
		"method": "GET",
		"user": {"id": "admin", "role": ["admin"]},
	}
		 with data.character as character
}

test_post_as_player_allowed {
	post_one = allow with input as {
		"path": ["api", "character"],
		"method": "POST",
		"user": {"id": "alice", "role": ["player"]},
	}
}

test_post_as_non_player_denied {
	not allow with input as {
		"path": ["api", "character"],
		"method": "POST",
		"user": {"id": "admin", "role": ["admin", "dm"]},
	}
}

test_patch_as_player_allowed {
	patch_one = allow with input as {
		"path": ["api", "character", "1"],
		"method": "PATCH",
		"user": {"id": "alice", "role": ["player"]},
	}
		 with data.character as character
}

test_patch_as_other_player_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "PATCH",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character as character
}

test_patch_as_non_player_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "PATCH",
		"user": {"id": "admin", "role": ["dm"]},
	}
		 with data.character as character
}

test_delete_as_player_allowed {
	allow with input as {
		"path": ["api", "character", "1"],
		"method": "DELETE",
		"user": {"id": "alice", "role": ["player"]},
	}
		 with data.character as character
}

test_delete_as_other_player_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "DELETE",
		"user": {"id": "bob", "role": ["player"]},
	}
		 with data.character as character
}

test_delete_as_non_player_denied {
	not allow with input as {
		"path": ["api", "character", "1"],
		"method": "DELETE",
		"user": {"id": "admin", "role": ["dm"]},
	}
		 with data.character as character
}
