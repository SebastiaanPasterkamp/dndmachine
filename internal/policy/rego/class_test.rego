package authz.class

class := {
	{
		"id": 1,
		"name": "Fighter",
		"description": "Armored and aggressive.",
		"phases": ["50m3-uu1d", "07h3r-uu1d"],
	},
	{
		"id": 2,
		"sub": 1,
		"name": "Battle Master",
		"description": "Armored, aggressive, and tactical.",
		"phases": ["50m3-uu1d", "07h3r-uu1d"],
	},
}

test_get_one_anonymous_denied {
	not allow with input as {
		"path": ["api", "class", "1"],
		"method": "GET",
	}
		 with data.class as class
}

test_get_all_anonymous_denied {
	not allow with input as {
		"path": ["api", "class"],
		"method": "GET",
	}
		 with data.class as class
}

test_get_one_as_user_allowed {
	allow with input as {
		"path": ["api", "class", "1"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.class as class
}

test_get_all_as_user_allowed {
	allow with input as {
		"path": ["api", "class"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.class as class
}

test_post_as_admin_allowed {
	post_one = allow with input as {
		"path": ["api", "class"],
		"method": "POST",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.class as class
}

test_post_as_non_admin_denied {
	not allow with input as {
		"path": ["api", "class"],
		"method": "POST",
		"user": {"id": 2, "role": ["dm"]},
	}
		 with data.class as class
}

test_patch_as_admin_allowed {
	patch_one = allow with input as {
		"path": ["api", "class", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.class as class
}

test_patch_as_other_denied {
	not allow with input as {
		"path": ["api", "class", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.class as class
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "class", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.class as class
}

test_delete_as_other_denied {
	not allow with input as {
		"path": ["api", "class", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.class as class
}
