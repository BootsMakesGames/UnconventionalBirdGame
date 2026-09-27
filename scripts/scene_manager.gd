extends Node2D

# Signals
signal scene_fade_in_finished
signal scene_fade_out_finished

# Variables for scene transition animation(s)
var transition_layer: CanvasLayer
var transition_rect: ColorRect
var transition_time: float = 0.5

func _ready():
# Instantiate transition layer in scene
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 100
	transition_rect = ColorRect.new()
	transition_rect.color = Color.BLACK
	transition_rect.anchor_right = 1
	transition_rect.anchor_bottom = 1
	transition_rect.visible = false
	transition_layer.add_child(transition_rect)
	get_tree().root.add_child.call_deferred(transition_layer)

# Fade from current scene to transition texture
func _fade_out():
	transition_rect.position = Vector2.ZERO
	transition_rect.z_index = 999
	transition_rect.modulate.a = 0
	transition_rect.visible = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(transition_rect, "modulate:a", 1.0, transition_time)
#	await tween.finished
	transition_rect.visible = false
	tween.tween_callback(func():
		scene_fade_out_finished.emit())

# Fade from transition texture to next scene
func _fade_in():
	transition_rect.position = Vector2.ZERO
	transition_rect.z_index = 999
	transition_rect.modulate.a = 1.0
	transition_rect.visible = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(transition_rect, "modulate:a", 0, transition_time)
#	await tween.finished
	tween.tween_callback(func():
		scene_fade_in_finished.emit())
	
