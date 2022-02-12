package lib.authn

is_authenticated {
	input.user.id
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

any_role {
	input.user.role[_] != ""
}
