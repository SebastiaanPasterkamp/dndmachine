package authz.character

default allow = false

allow {
	input.path = ["api", "character", path_id]
	input.method == "GET"
	input.user.id
	character_id := to_number(path_id)
	allowed[char]
	char.id == character_id
}

allow {
	input.path == ["api", "character"]
	input.method == "GET"
	input.user.id
	allowed[char]
}

is_admin {
	input.user.role[_] == "admin"
}

# Admin can see everything
allowed[char] {
	is_admin
	char = data.character[_]
}

# Non-admin needs to own the character
allowed[char] {
	not is_admin
	char = data.character[_]
	char.user_id = input.user.id
}

# Non-admin needs to be in a party with the character
allowed[char] {
	not is_admin
	char = data.character[_]
	member = char.party.members[_]
	member.user_id == input.user.id
}
