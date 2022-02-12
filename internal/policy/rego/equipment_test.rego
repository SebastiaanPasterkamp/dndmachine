package authz.equipment

equipment := {
	{
		"id": 1,
		"type": "trinket",
		"name": "An old key",
		"weight": "2oz",
	},
	{
		"id": 2,
		"type": "trinket",
		"name": "A glass eye",
		"weight": "1oz",
	},
}

test_get_one_anonymous_denied {
	not allow with input as {
		"path": ["api", "equipment", "1"],
		"method": "GET",
	}
		 with data.equipment as equipment
}

test_get_all_anonymous_denied {
	not allow with input as {
		"path": ["api", "equipment"],
		"method": "GET",
	}
		 with data.equipment as equipment
}

test_get_one_as_user_allowed {
	allow with input as {
		"path": ["api", "equipment", "1"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.equipment as equipment
}

test_get_all_as_user_allowed {
	allow with input as {
		"path": ["api", "equipment"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.equipment as equipment
}

test_post_as_admin_allowed {
	post_one = allow with input as {
		"path": ["api", "equipment"],
		"method": "POST",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.equipment as equipment
}

test_post_as_non_admin_denied {
	not allow with input as {
		"path": ["api", "equipment"],
		"method": "POST",
		"user": {"id": 2, "role": ["dm"]},
	}
		 with data.equipment as equipment
}

test_patch_as_admin_allowed {
	patch_one = allow with input as {
		"path": ["api", "equipment", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.equipment as equipment
}

test_patch_as_other_denied {
	not allow with input as {
		"path": ["api", "equipment", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.equipment as equipment
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "equipment", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.equipment as equipment
}

test_delete_as_other_denied {
	not allow with input as {
		"path": ["api", "equipment", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.equipment as equipment
}
