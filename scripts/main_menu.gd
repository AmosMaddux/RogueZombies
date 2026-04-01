extends Control

@onready var fade: ColorRect = $BG/Fade

func _ready() -> void:
	# Ensure the fade starts transparent and mouse clicks can pass through it initially
	fade.color.a = 0
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_start_button_pressed() -> void:
	_transition_to_scene("res://scenes/main.tscn")

func _on_controls_button_pressed() -> void:
	_transition_to_scene("res://scenes/controls_tut.tscn")

func _on_options_button_pressed() -> void:
	_transition_to_scene("res://scenes/Options.tscn")

func _transition_to_scene(scene_path: String) -> void:
	# Prevent further input during transition
	fade.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Create a tween to animate the alpha property to 1 (fully opaque)
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
	
	# Wait for the tween to finish, then change the scene
	tween.finished.connect(func(): get_tree().change_scene_to_file(scene_path))
