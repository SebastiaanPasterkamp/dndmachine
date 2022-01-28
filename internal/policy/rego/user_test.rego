package authz.user

user := {
	{
		"id": 1,
		"name": "admin",
		"role": ["admin"],
	},
	{
		"id": 2,
		"name": "alice",
		"role": ["user"],
	},
}

test_get_anonymous_denied {
	not allow with input as {
		"path": ["api", "user", "2"],
		"method": "GET",
	}
		 with data.user as user
}

test_get_own_user_allowed {
	get_one = allow with input as {
		"path": ["api", "user", "2"],
		"method": "GET",
		"user": {"id": 2},
	}
		 with data.user as user
}

test_get_some_other_user_denied {
	not allow with input as {
		"path": ["api", "user", "2"],
		"method": "GET",
		"user": {"id": 3},
	}
		 with data.user as user
}

test_get_as_admin_allowed {
	get_one = allow with input as {
		"path": ["api", "user", "2"],
		"method": "GET",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.user as user
}

test_list_as_user_allowed {
	get_list = allow with input as {
		"path": ["api", "user"],
		"method": "GET",
		"user": {"id": 2},
	}
		 with data.user as user
}

test_list_as_admin_allowed {
	get_list = allow with input as {
		"path": ["api", "user"],
		"method": "GET",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.user as user
}

test_post_as_admin_allowed {
	post_one = allow with input as {
		"path": ["api", "user"],
		"method": "POST",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.user as user
}

test_post_as_non_admin_denied {
	not allow with input as {
		"path": ["api", "user"],
		"method": "POST",
		"user": {"id": 2, "role": ["dm"]},
	}
		 with data.user as user
}

test_patch_as_admin_allowed {
	patch_one = allow with input as {
		"path": ["api", "user", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.user as user
}

test_patch_as_self_allowed {
	patch_one = allow with input as {
		"path": ["api", "user", "1"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.user as user
}

test_patch_as_other_denied {
	not allow with input as {
		"path": ["api", "user", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.user as user
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "user", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.user as user
}

test_delete_as_self_allowed {
	allow with input as {
		"path": ["api", "user", "1"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.user as user
}

test_delete_as_other_denied {
	not allow with input as {
		"path": ["api", "user", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.user as user
}
