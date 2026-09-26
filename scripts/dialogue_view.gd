extends Node2D

# Ready UI elements
@onready var character = %CharacterSprite
@onready var dialogue_ui = %DialogueUI

# Set current dialogue line to 0
var current_line : int
const FIRST_LINE = 0

# Store dialogue lines for scene
var dialogue_lines : Array = []


func _ready():
	# Set character dialogue
	dialogue_lines = load_character_dialogue("dodo")
	
	# Connect signals
	dialogue_ui.text_animation_finished.connect(_on_text_animation_finished)
	dialogue_ui.choice_selected.connect(_on_choice_selected)
	
	# Process first line of dialogue
	current_line = FIRST_LINE
	process_current_line() 
	

func _input(event):
	# Handles switching between lines of dialogue
	var line = dialogue_lines[current_line]
	var has_choices = line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialogue_ui.animate_text:
			dialogue_ui.skip_text_animation()
		else:
			if current_line < len(dialogue_lines) -1:
				current_line += 1
				process_current_line()
	elif event.is_action_pressed("prev_line"):
		if dialogue_ui.animate_text:
			dialogue_ui.skip_text_animation()
		else:
			if current_line > FIRST_LINE:
				current_line -= 1
				process_current_line()
	else:
		pass

# Update current line of text
func process_current_line():
	var line = dialogue_lines[current_line]
	
	if line.has("goto"):
		current_line = get_anchor_location(line["goto"])
		process_current_line()
		return
	
	if line.has("anchor"):
		current_line += 1
		process_current_line()
		return
	
	if line.has("choices"):
		dialogue_ui.display_choices(line["choices"])
	
	else:
		var character_name = Character.get_enum_from_string(line["speaker"])
		dialogue_ui.change_line(character_name, line["text"])
		character.change_character(character_name)

# Get line index of desired anchor
func get_anchor_location(anchor: String):
	for i in range(dialogue_lines.size()):
		if dialogue_lines[i].has("anchor") and dialogue_lines[i]["anchor"] == anchor:
			return i
	printerr("Error: Could not find anchor '" + anchor + "'")
	return null

func _on_choice_selected(anchor: String):
	current_line = get_anchor_location(anchor)
	process_current_line()

# TODO: Stop speaking animation when text is fully visible
func _on_text_animation_finished():
	character.play_idle_animation()
	
# Read text data from json files
func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var filetext = file.get_as_text()
	var filecontent = JSON.parse_string(filetext)
	return filecontent
	
# Load character dialogue from file
func load_character_dialogue(filename):
	var character_dialogue = {}
	var character_file = str("res://json_files/character_dialogue/" + filename + ".json")
	for file in DirAccess.get_files_at("res://json_files/character_dialogue/"):
		if file.get_file() == str(filename + ".json"):  
			character_dialogue = readJSON(character_file)
	return character_dialogue
