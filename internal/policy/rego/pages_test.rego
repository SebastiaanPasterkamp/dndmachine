package authz.pages

test_get_home_allowed {
	allow with input as {
		"path": [""],
		"method": "GET",
		"user": {"id": 1},
	}
}

test_get_anonymous_home_allowed {
	allow with input as {
		"path": [""],
		"method": "GET",
	}
}

test_get_equipment_allowed {
	allow with input as {
		"path": ["equipment"],
		"method": "GET",
		"user": {"id": 1, "role": ["player"]},
	}
}

test_get_anonymous_equipment_denied {
	not allow with input as {
		"path": ["equipment"],
		"method": "GET",
	}
}

test_get_dm_without_role_denied {
	not allow with input as {
		"path": ["dungeon-master"],
		"method": "GET",
		"user": {"id": 1, "role": ["player"]},
	}
}

test_get_dm_as_dm_allowed {
	allow with input as {
		"path": ["dungeon-master"],
		"method": "GET",
		"user": {"id": 1, "role": ["dm"]},
	}
}

test_get_dm_as_admin_allowed {
	allow with input as {
		"path": ["dungeon-master"],
		"method": "GET",
		"user": {"id": 1, "role": ["admin"]},
	}
}

test_get_admin_as_admin_allowed {
	allow with input as {
		"path": ["user"],
		"method": "GET",
		"user": {"id": 1, "role": ["admin"]},
	}
}

test_get_admin_without_admin_denied {
	not allow with input as {
		"path": ["user"],
		"method": "GET",
		"user": {"id": 1, "role": ["dm"]},
	}
}
