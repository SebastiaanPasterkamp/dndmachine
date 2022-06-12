package authz.background

background := {
	{
		"id": 1,
		"name": "Hero",
		"description": "Revered.",
	},
	{
		"id": 2,
		"name": "Soldier",
		"description": "Army boy.",
	},
}

test_get_one_anonymous_denied {
	not allow with input as {
		"path": ["api", "background", "1"],
		"method": "GET",
	}
		 with data.background as background
}

test_get_all_anonymous_denied {
	not allow with input as {
		"path": ["api", "background"],
		"method": "GET",
	}
		 with data.background as background
}

test_get_one_as_user_allowed {
	allow with input as {
		"path": ["api", "background", "1"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.background as background
}

test_get_all_as_user_allowed {
	allow with input as {
		"path": ["api", "background"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.background as background
}

test_post_as_admin_allowed {
	post_one = allow with input as {
		"path": ["api", "background"],
		"method": "POST",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.background as background
}

test_post_as_non_admin_denied {
	not allow with input as {
		"path": ["api", "background"],
		"method": "POST",
		"user": {"id": 2, "role": ["dm"]},
	}
		 with data.background as background
}

test_patch_as_admin_allowed {
	patch_one = allow with input as {
		"path": ["api", "background", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.background as background
}

test_patch_as_other_denied {
	not allow with input as {
		"path": ["api", "background", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.background as background
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "background", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.background as background
}

test_delete_as_other_denied {
	not allow with input as {
		"path": ["api", "background", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.background as background
}
