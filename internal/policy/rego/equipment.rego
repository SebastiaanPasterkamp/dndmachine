package authz.equipment

import data.lib.authn

default allow = false

get_one := ["type", "name", "config"]

get_list := ["type", "name", "config"]

patch_one := ["name", "config"]

post_one := ["type", "name", "config"]

allow = get_one {
	input.path = ["api", "equipment", path_id]
	input.method == "GET"
	authn.is_authenticated
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = get_list {
	input.path == ["api", "equipment"]
	input.method == "GET"
	authn.is_authenticated
	allowed[item]
}

allow = patch_one {
	input.path = ["api", "equipment", path_id]
	input.method == "PATCH"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow {
	input.path = ["api", "equipment", path_id]
	input.method == "DELETE"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = post_one {
	input.path == ["api", "equipment"]
	input.method == "POST"
	authn.is_admin
}

# All users with a role can GET equipment
allowed[item] {
	input.method == "GET"
	authn.any_role
	item = data.equipment[_]
}

# admins can do everything
allowed[item] {
	authn.is_admin
	item = data.equipment[_]
}
