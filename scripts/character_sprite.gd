extends Node2D

@onready var animated_sprite = $Character

# Preload character sprite frames
const CHARACTER_FRAMES = {
	"Dodo": preload("res://sprites/aanimations/dodo_sprites.tres"),
	"Dodont": preload("res://sprites/aanimations/dodont_sprites.tres")
}

const EMOTIONS_LIST = ["idle", "happy", "distressed"]

func _ready():
	pass

# Change between characters & emotions
func change_character(character_name: String, emotion: String, is_talking: bool = true):
	if character_name in Character.Name:
		animated_sprite.sprite_frames = Character.CHARACTER_DETAILS[character_name]
		if emotion in EMOTIONS_LIST:
			animated_sprite.play(emotion)
	else: 
		play_idle_animation()

func play_idle_animation():
	animated_sprite.play("idle")
