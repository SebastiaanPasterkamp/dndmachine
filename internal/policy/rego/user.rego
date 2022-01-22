package authz.user

default allow = false

allow {
	input.path = ["api", "user", path_id]
	input.method == "GET"
	input.user.id != null
	user_id := to_number(path_id)
	allowed[usr]
	usr.id == user_id
}

allow {
	input.path = ["api", "user"]
	input.method == "GET"
	input.user.id != null
	allowed[usr]
}

is_admin {
	input.user.role[_] == "admin"
}

# Admin can see everything
allowed[usr] {
	is_admin
	usr = data.user[_]
}

# Non-admin needs to be the user
allowed[usr] {
	not is_admin
	usr = data.user[_]
	usr.id = input.user.id
}