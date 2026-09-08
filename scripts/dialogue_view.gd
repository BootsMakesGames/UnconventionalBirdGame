extends Node2D

@onready var character = %CharacterSprite
@onready var textbox = %DialogueUI

const TEMP_DIALOGUE : Array[String] = [
	"Dodo: I've truly become a silly little guy lately.",
	"Dodo: I'm the king of water cup city!",
	"Dodo: Productivity does not determine my worth."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Process first line of dialogue
	process_line(parse_line(TEMP_DIALOGUE[0]))


func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return {
		"speaker_name": line_info[0],
		"dialogue_text": line_info[1]
	}
	
func process_line(line_info: Dictionary):
	textbox.speaker_name.text = line_info["speaker_name"]
	textbox.dialogue_text.text = line_info["dialogue_text"]
