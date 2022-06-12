package authz.characteristic_option

import data.lib.authn

default allow = false

get_one := ["uuid", "name", "type", "config"]

get_list := ["uuid", "name", "type", "config"]

patch_one := ["name", "config"]

post_one := ["uuid", "name", "type", "config"]

allow = get_one {
	input.path = ["api", "characteristic", path_id]
	input.method == "GET"
	authn.is_authenticated
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = get_list {
	input.path == ["api", "characteristic"]
	input.method == "GET"
	authn.is_authenticated
	allowed[item]
}

allow = patch_one {
	input.path = ["api", "characteristic", path_id]
	input.method == "PATCH"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow {
	input.path = ["api", "characteristic", path_id]
	input.method == "DELETE"
	authn.is_admin
	item_id := to_number(path_id)
	allowed[item]
	item.id == item_id
}

allow = post_one {
	input.path == ["api", "characteristic"]
	input.method == "POST"
	authn.is_admin
}

# All users with a role can GET characteristic options
allowed[item] {
	input.method == "GET"
	item = data.characteristic_option[_]
}

# admins can do everything
allowed[item] {
	authn.is_admin
	item = data.characteristic_option[_]
}
