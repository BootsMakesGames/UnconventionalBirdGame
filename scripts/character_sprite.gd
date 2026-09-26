extends Node2D

@onready var animated_sprite = $Character

const EMOTIONS_LIST = ["idle", "happy", "distressed"]

func _ready():
	pass

# Change between characters & emotions
func change_character(character_name: Character.Name, emotion: String, is_talking: bool = true):
	var sprite_frames = Character.CHARACTER_DETAILS[character_name]["sprite"]
#	var mouth_position = "talking" if is_talking else "idle"
#	var sprite_name = emotion + "-" + mouth_position
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		if is_talking:
			if emotion in EMOTIONS_LIST:
				animated_sprite.play(emotion)
			else:
				animated_sprite.play("happy")
		else: 
			play_idle_animation()
	else: 
		play_idle_animation()

func play_idle_animation():
	animated_sprite.play("idle")
