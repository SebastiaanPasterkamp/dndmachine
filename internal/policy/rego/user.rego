package authz.user

default allow = false

allow {
	input.path = ["api", "user", path_id]
	input.method == "GET"
	input.user.id != null
	user_id := to_number(path_id)
	allowed[user]
	user.id == user_id
}

is_admin {
	input.user.role[_] == "admin"
}

# Admin can see everything
allowed[user] {
	is_admin
	user = data.user
}

# Non-admin needs to be the user
allowed[user] {
	not is_admin
	user = data.user
	user.id = input.user.id
}
