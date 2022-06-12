package authz.characteristic_option

characteristic_option := {
	{
		"id": 1,
		"uuid": "50m3-uu1d",
		"name": "Option 1",
	},
	{
		"id": 2,
		"uuid": "07h3r-uu1d",
		"name": "Option 2",
	},
}

test_get_one_anonymous_denied {
	not allow with input as {
		"path": ["api", "characteristic", "1"],
		"method": "GET",
	}
		 with data.characteristic_option as characteristic_option
}

test_get_all_anonymous_denied {
	not allow with input as {
		"path": ["api", "characteristic"],
		"method": "GET",
	}
		 with data.characteristic_option as characteristic_option
}

test_get_one_as_user_allowed {
	allow with input as {
		"path": ["api", "characteristic", "1"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_get_all_as_user_allowed {
	allow with input as {
		"path": ["api", "characteristic"],
		"method": "GET",
		"user": {"id": 10, "role": ["player"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_post_as_admin_allowed {
	post_one = allow with input as {
		"path": ["api", "characteristic"],
		"method": "POST",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_post_as_non_admin_denied {
	not allow with input as {
		"path": ["api", "characteristic"],
		"method": "POST",
		"user": {"id": 2, "role": ["dm"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_patch_as_admin_allowed {
	patch_one = allow with input as {
		"path": ["api", "characteristic", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_patch_as_other_denied {
	not allow with input as {
		"path": ["api", "characteristic", "2"],
		"method": "PATCH",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_delete_as_admin_allowed {
	allow with input as {
		"path": ["api", "characteristic", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["admin"]},
	}
		 with data.characteristic_option as characteristic_option
}

test_delete_as_other_denied {
	not allow with input as {
		"path": ["api", "characteristic", "2"],
		"method": "DELETE",
		"user": {"id": 1, "role": ["dm"]},
	}
		 with data.characteristic_option as characteristic_option
}
