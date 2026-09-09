extends Control

@onready var dialogue = $DialogueBox/Dialogue
@onready var speaker_name = $NameBox/SpeakerName

const TYPEWRITER_SPEED : int = 30
var animate_text : bool = false
var current_visible_characters : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate_text:
		if dialogue.visible_ratio < 1:
			dialogue.visible_ratio += (1.0/dialogue.text.length()) * (TYPEWRITER_SPEED * delta)
			current_visible_characters = dialogue.visible_characters
		else: animate_text = false

func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialogue.text = line
	dialogue.visible_characters = 0
	animate_text = true

func _on_next_arrow_pressed() -> void:
	pass # Replace with function body.

func _on_prev_arrow_pressed() -> void:
	pass # Replace with function body.
