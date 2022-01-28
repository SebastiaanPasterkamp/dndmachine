package authz.character

default allow = false

get_one := ["user_id", "name", "level", "config"]

get_list := ["user_id", "name", "level"]

patch_one := ["name", "config"]

post_one := ["user_id", "name", "level", "config"]

allow = get_one {
	input.path = ["api", "character", path_id]
	input.method == "GET"
	input.user.id
	any_role
	character_id := to_number(path_id)
	allowed[char]
	char.id == character_id
}

allow = get_list {
	input.path == ["api", "character"]
	input.method == "GET"
	input.user.id
	any_role
	allowed[char]
}

allow = patch_one {
	input.path = ["api", "character", path_id]
	input.method == "PATCH"
	input.user.id
	character_id := to_number(path_id)
	allowed[char]
	char.id == character_id
}

allow {
	input.path = ["api", "character", path_id]
	input.method == "DELETE"
	input.user.id
	character_id := to_number(path_id)
	allowed[char]
	char.id == character_id
}

allow = post_one {
	input.path == ["api", "character"]
	input.method == "POST"
	input.user.id
	input.user.role[_] = "player"
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

# Admin can see everything
allowed[char] {
	is_admin
	char = data.character[_]
}

# Non-admin needs to be a player, and own the character
allowed[char] {
	not is_admin
	char = data.character[_]
	char.user_id = input.user.id
}

# Non-admin can sometimes read
allowed[char] {
	not is_admin
	readable[char]
}

# DMs can read
readable[char] {
	input.method == "GET"
	is_dm
	char = data.character[_]
}

# Non-DM players can read if they are in a party with the character
readable[char] {
	input.method == "GET"
	not is_dm
	is_player
	char = data.character[_]
	member = char.party.members[_]
	member.user_id == input.user.id
}
