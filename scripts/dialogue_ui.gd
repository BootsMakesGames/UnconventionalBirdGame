extends Control

# Ready UI elements
@onready var dialogue = $DialogueBox/Dialogue
@onready var speaker_name = $NameBox/SpeakerName
@onready var choice_options = %ChoiceOptions

# Preload dialogue button scene
const DIALOGUE_OPTIONS = preload("res://scenes/dialogue_option.tscn")

# Emitted when typewriter effect is completed
signal text_animation_finished
# Emitted when dialogue option button pressed
signal choice_selected

# Adjusts text animation speed
const TYPEWRITER_SPEED : int = 30

# Resets text animation variables
var animate_text : bool = false
var current_visible_characters : int = 0


func _ready():
# Start with dialogue options not visible
	choice_options.hide()

# Handles typewriter animation
func _process(delta):
	if animate_text:
		if dialogue.visible_ratio < 1:
			dialogue.visible_ratio += (1.0/dialogue.text.length()) * (TYPEWRITER_SPEED * delta)
			current_visible_characters = dialogue.visible_characters
		else: 
			animate_text = false
			text_animation_finished.emit()

# Called when moving to the next line of dialogue; resets text animation
func change_line(character_name: Character.Name, line: String):
	speaker_name.text = Character.CHARACTER_DETAILS[character_name]["name"]
	current_visible_characters = 0
	dialogue.text = line
	dialogue.visible_characters = 0
	animate_text = true

# Immediately reveals all text
func skip_text_animation():
	dialogue.visible_ratio = 1

# Create & show dialogue options buttons
func display_choices(choices: Array):
	# Clear previous choices
	for child in choice_options.get_children():
		child.queue_free()
	# Create & assign UI buttons for current choices
	for choice in choices:
		var choice_button = DIALOGUE_OPTIONS.instantiate()
		choice_button.text = choice["text"]
		choice_button.pressed.connect(_on_option_pressed.bind(choice["goto"]))
		choice_options.add_child(choice_button)
	choice_options.show()

# Emit signal when dialogue option is selected
func _on_option_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_options.hide()

#TODO: View next/previous line of dialogue
func _on_next_arrow_pressed():
	pass
func _on_prev_arrow_pressed():
	pass
