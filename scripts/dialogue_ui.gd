extends Control

# Ready UI elements
@onready var dialogue = $DialogueBox/Dialogue
@onready var speaker_name = $NameBox/SpeakerName

# Emitted when typewriter effect is completed
signal animation_finished

# Adjusts text animation speed
const TYPEWRITER_SPEED : int = 30

# Resets text animation variables
var animate_text : bool = false
var current_visible_characters : int = 0


func _ready():
	pass

# Handles typewriter animation
func _process(delta):
	if animate_text:
		if dialogue.visible_ratio < 1:
			dialogue.visible_ratio += (1.0/dialogue.text.length()) * (TYPEWRITER_SPEED * delta)
			current_visible_characters = dialogue.visible_characters
		else: 
			animate_text = false
			animation_finished.emit

# Called when moving to the next line of dialogue; resets text animation
func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialogue.text = line
	dialogue.visible_characters = 0
	animate_text = true

# Immediately reveals all text
func skip_text_animation():
	dialogue.visible_ratio = 1

#TODO: View next/previous line of dialogue
func _on_next_arrow_pressed():
	pass
func _on_prev_arrow_pressed():
	pass
