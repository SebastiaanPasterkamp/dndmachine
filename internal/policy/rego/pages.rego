package authz.pages

default allow = false

allow {
	input.path == [""]
	input.method == "GET"
}

allow {
	input.path == private_pages[_]
	input.method == "GET"
	input.user.id
}

allow {
	input.path == ["adventure-league"]
	input.method == "GET"
	input.user.dci
}

allow {
	input.path == dm_pages[_]
	input.method == "GET"
	input.user.id
	is_admin
}

allow {
	input.path == dm_pages[_]
	input.method == "GET"
	input.user.id
	is_dm
}

allow {
	input.path == admin_pages[_]
	input.method == "GET"
	is_admin
}

private_pages = [
	["character"],
	["session"],
	["party"],
	["item"],
	["spell"],
	["language"],
	["weapon"],
	["armor"],
]

dm_pages = [
	["dungeon-master"],
	["monster"],
	["npc"],
	["encounter"],
	["campaign"],
]

admin_pages = [
	["admin"],
	["user"],
]

is_admin {
	input.user.role[_] == "admin"
}

is_dm {
	input.user.role[_] == "dm"
}
