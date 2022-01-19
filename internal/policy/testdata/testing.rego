package testing

default allow = false

allow {
	input.path = ["user", user_id]
	input.method == "GET"
	input.user.id != null
	user_id == input.user.id
}
