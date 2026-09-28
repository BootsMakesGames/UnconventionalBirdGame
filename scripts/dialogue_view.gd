extends Node2D

# Ready UI elements
@onready var character = %CharacterSprite
@onready var dialogue_ui = %DialogueUI
@onready var background = %Background2D
@onready var music_player = %BackgroundMusic

# Set current dialogue line to 0
var current_line : int
const FIRST_LINE = 0

# Store dialogue lines for scene
var dialogue_lines : Array = []
var dialogue_file : String = "simple_script"
var speaker 
var current_emotion

# Store background image & background music
var location : String 
var music : String 


func _ready():
	# Set character dialogue
	dialogue_lines = load_character_dialogue(dialogue_file)
	
	# Connect signals
	dialogue_ui.text_animation_finished.connect(_on_text_animation_finished)
	dialogue_ui.choice_selected.connect(_on_choice_selected)
	SceneManager.scene_fade_out_finished.connect(_on_scene_faded_out)
	SceneManager.scene_fade_in_finished.connect(_on_scene_faded_in)
	
	# Process first line of dialogue
	current_line = FIRST_LINE
	process_current_line() 
	

func _input(event):
	# Handles switching between lines of dialogue
	var line = parse_line(dialogue_lines[current_line])
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

# Parse string into dictionary
func parse_line(line: String):
	var line_info = line.split(":")
	assert(len(line_info) >= 2)
	var clean_line_info = line_info[1].lstrip(' ')
	line_info[1] = clean_line_info
	return line_info

# Update current line of text
func process_current_line():
	# Check if current line exists
	if current_line >= dialogue_lines.size() or current_line < 0:
		printerr("Current line out of bounds.")
		return
	
	var line = parse_line(dialogue_lines[current_line])
	print_debug(line)
	
	# Set background image for current scene
	if line[0] == "location":
		location = line[1]
		var bg_image = "res://placeholder_art/backgrounds/" + location + ".png"
		background.texture = load(bg_image)
		current_line += 1
		process_current_line()
		return
	
	# Set music for current scene
	if line[0] == "music":
		music = line[1]
		var bg_music = "res://placeholder_art/" + music + ".mp3"
		music_player.stream = load(bg_music)
		music_player.play()
		current_line += 1
		process_current_line()
		return
	
	# Update character sprite
	if line[0] == "character":
		var character_name = Character.get_enum_from_string(line[1])
		speaker = character_name
		dialogue_ui.change_speaker(speaker)
		current_line += 1
		process_current_line()
		return
	
	# Change character emotion
	if line[0] == "feeling":
		current_emotion = line[1]
		current_line += 1
		process_current_line()
		return
	
	# Jump to specified anchor in dialogue script
	if line[0] == "jump":
		current_line = get_land_location(line[1])
		process_current_line()
		return
	
	# Designate dialogue anchor point
	if line[0] == "land":
		current_line += 1
		process_current_line()
		return
		
	# Transition to next scene
	if line[0] == "next_scene":
		dialogue_file = line[1] if !line[1].is_empty() else ""
		SceneManager._fade_out()
		return
		
	# Display dialogue choice options
	if line[0] == "choices":
		dialogue_ui.display_choices(line[1])
	
	# Display line of dialogue & character sprite emotion
	elif line[0] == "text":
		character.change_character(speaker, current_emotion)
		dialogue_ui.change_line(line[1])
		#current_line += 1
		#process_current_line()
		#return
	
	# Skip & document any lines in script not accounted for in code
	else:
		print_debug("Skipped line: " + line[1])
		current_line += 1
		process_current_line()
		return

# Get line index of desired anchor
func get_land_location(land: String):
	for i in range(dialogue_lines.size()):
		var parsed_line = parse_line(dialogue_lines[i])
		if parsed_line[0] == "land" and parsed_line[1] == land:
			print_debug(i)
			return i
	printerr("Error: Could not find anchor '" + land + "'")
	return null

# Go to desired anchor when dialogue choice is selected
func _on_choice_selected(land: String):
	current_line = get_land_location(land)
	process_current_line()

# Stop speaking animation when text is fully visible
func _on_text_animation_finished():
	character.play_idle_animation()
	
# Manages scene transitions
func _on_scene_faded_out():
	dialogue_lines = load_character_dialogue(dialogue_file)
	current_line = FIRST_LINE
	dialogue_ui.dialogue.visible_characters = 0
	SceneManager._fade_in()
		
	#var parsed_line = parse_line(dialogue_lines[current_line])
	#if parsed_line[0] == "location":
	#	var bg_image = "res://placeholder_art/backgrounds/" + location + ".png"
	#	background.texture = load(bg_image)
	
	#var music_file = "res://placeholder_art/" + music + ".mp3"
	#music_player.stream = load(music_file)
	#music_player.play()
	current_line += 1
	
func _on_scene_faded_in():
	process_current_line()

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
