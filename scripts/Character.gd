class_name Character
extends Node

## FROM TUTORIAL ##
enum Name {
	PLAYER,
	DODO,
	DODONT
}

const CHARACTER_DETAILS: Dictionary = {
	Name.PLAYER: {
		"name": "Player",
		"species": "Human",
		"sprite": null,
		"affinity_points": null,
		"gift1": null,
		"gift2": null,
		"current_line": null},
	Name.DODO: {
		"name": "Dodo",
		"species": "Dodo",
		"sprite": preload("res://sprites/aanimations/dodo_sprites.tres"),
		"affinity_points": 0,
		"gift1": "telescope",
		"gift2": "funny_hat",
		"current_line": 0},
	Name.DODONT: {
		"name": "Dodon't",
		"species": "Dodo",
		"sprite": preload("res://sprites/aanimations/dodont_sprites.tres"),
		"affinity_points": 0,
		"gift1": "telescope",
		"gift2": "funny_hat",
		"current_line": 0},
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid character name: " + string_value)
		return -1
