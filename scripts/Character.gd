class_name Character
extends Node

## FROM TUTORIAL ##
enum Name {
	DODO
}

const CHARACTER_DETAILS: Dictionary = {
	Name.DODO: {
		"name": "Dodo",
		"species": "Dodo",
		"sprite": preload("res://scenes/character_sprite.tscn"),
		"affinity_points": 0,
		"gift1": "telescope",
		"gift2": "funny_hat"
	}
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid character name: " + string_value)
		return -1
