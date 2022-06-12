package authz.class

import data.lib.authn

default allow = false

get_one := ["sub", "name", "phases"]

get_list := ["sub", "name", "phases"]

patch_one := ["name", "phases"]

post_one := ["sub", "name", "phases"]

allow = get_one {
	input.path = ["api", "class", path_id]
	input.method == "GET"
	authn.is_authenticated
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = get_list {
	input.path == ["api", "class"]
	input.method == "GET"
	authn.is_authenticated
	allowed[item]
}

allow = patch_one {
	input.path = ["api", "class", path_id]
	input.method == "PATCH"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow {
	input.path = ["api", "class", path_id]
	input.method == "DELETE"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = post_one {
	input.path == ["api", "class"]
	input.method == "POST"
	authn.is_admin
}

# All users with a role can GET classes
allowed[item] {
	input.method == "GET"
	authn.any_role
	item = data.class[_]
}

# admins can do everything
allowed[item] {
	authn.is_admin
	item = data.class[_]
}
