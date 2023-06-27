package authz.character_option

default allow = false

get_one := ["uuid", "name", "type", "config"]

get_list := ["uuid", "name", "type", "config"]

patch_one := ["name", "config"]

post_one := ["uuid", "name", "type", "config"]

allow = get_one {
	input.path = ["api", "character-option", path_id]
	input.method == "GET"
	allowed[option]
	option.id == to_number(path_id)
}

allow = get_one {
	input.path = ["api", "character-option", "uuid", uuid]
	input.method == "GET"
	allowed[option]
	option.uuid == uuid
}

allow = get_list {
	input.path == ["api", "character-option"]
	input.method == "GET"
	allowed[option]
}

allow = patch_one {
	input.path = ["api", "character-option", path_id]
	input.method == "PATCH"
	allowed[option]
	option.id == to_number(path_id)
}

allow {
	input.path = ["api", "character-option", path_id]
	input.method == "DELETE"
	allowed[option]
	option.id == to_number(path_id)
}

allow = post_one {
	input.path == ["api", "character-option"]
	input.method == "POST"
	is_admin
}

any_role {
	input.user.role[_] == {"player", "dm", "admin"}[_]
}

is_player {
	input.user.role[_] == "player"
}

is_dm {
	input.user.role[_] == "dm"
}

is_admin {
	input.user.role[_] == "admin"
}

# Admin can do everything with character options
allowed[option] {
	is_admin
	option = data.character_option[_]
}

# Other roles can only read character options
allowed[option] {
	input.method == "GET"
	any_role
	option = data.character_option[_]
}
