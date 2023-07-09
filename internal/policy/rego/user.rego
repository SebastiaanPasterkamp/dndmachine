package authz.user

default allow = false

get_one := ["username", "role", "email", "google_id", "config"]

get_list := ["username", "role", "config"]

patch_one := ["username", "password", "email", "google_id", "config"]

patch_admin := ["username", "password", "role", "email", "google_id", "config"]

post_one := ["username", "password", "role", "email", "config"]

allow = get_one {
	input.path = ["api", "user", path_id]
	input.method == "GET"
	input.user.id
	user_id := to_number(path_id)
	allowed[usr]
	usr.id == user_id
}

allow = get_list {
	input.path == ["api", "user"]
	input.method == "GET"
	input.user.id
	allowed[usr]
}

allow = patch_one {
	input.path = ["api", "user", path_id]
	input.method == "PATCH"
	input.user.id
	user_id := to_number(path_id)
	not is_admin
	allowed[usr]
	usr.id == user_id
}

allow = patch_admin {
	input.path = ["api", "user", path_id]
	input.method == "PATCH"
	input.user.id
	user_id := to_number(path_id)
	is_admin
	allowed[usr]
	usr.id == user_id
}

allow {
	input.path = ["api", "user", path_id]
	input.method == "DELETE"
	input.user.id
	user_id := to_number(path_id)
	allowed[usr]
	usr.id == user_id
}

allow = post_one {
	input.path == ["api", "user"]
	input.method == "POST"
	input.user.id
	is_admin
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
