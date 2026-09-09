extends Node2D

# Ready UI elements
@onready var character = %CharacterSprite
@onready var textbox = %DialogueUI

# Set current dialogue line to 0
var current_line : int
const FIRST_LINE = 0

# FROM TUTORIAL
const TEMP_DIALOGUE : Array[String] = [
	"Dodo: I've truly become a silly little guy lately.",
	"Dodo: I'm the king of water cup city!",
	"Dodo: Productivity does not determine my worth.",
	"Dodo: The bird was touched by the gods themselves.",
	"Dodo: By <i>the bird</i> I mean me."
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	textbox.animation_finished.connect(_on_text_animation_finished)
	
	# Process first line of dialogue
	current_line = FIRST_LINE
	process_current_line() 

func _input(event):
	if event.is_action_pressed("next_line"):
		if textbox.animate_text:
			textbox.skip_text_animation()
		else:
			if current_line < len(TEMP_DIALOGUE) -1:
				current_line += 1
				process_current_line()
	elif event.is_action_pressed("prev_line"):
		if textbox.animate_text:
			textbox.skip_text_animation()
		else:
			if current_line > FIRST_LINE:
				current_line -= 1
				process_current_line()
	else:
		pass

# FROM TUTORIAL
# TODO: Replace with some kind of READ function
func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	return {
		"speaker_name": line_info[0],
		"dialogue_text": line_info[1]
	}
func process_current_line():
	var line = TEMP_DIALOGUE[current_line]
	var line_info = parse_line(line)
	textbox.change_line(line_info["speaker_name"], line_info["dialogue_text"])
	character.change_character()
	
func _on_text_animation_finished():
	pass
