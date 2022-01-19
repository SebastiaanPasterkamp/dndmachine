package authz.character

default allow = false

allow {
	input.path = ["api", "character", path_id]
	input.method == "GET"
	input.user.id != null
	character_id := to_number(path_id)
	allowed[character]
	character.id == character_id
}

is_admin {
	input.user.role[_] == "admin"
}

# Admin can see everything
allowed[character] {
	is_admin
	character = data.character
}

# Non-admin needs to own the character
allowed[character] {
	not is_admin
	character = data.character
	character.user_id = input.user.id
}

# Non-admin needs to be in a party with the character
allowed[character] {
	not is_admin
	character = data.character
	member = character.party.members[_]
	member.user_id == input.user.id
}
