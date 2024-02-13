@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"AnimatedControl"
		,"Control",
		preload("res://addons/fast_ui/animation_data/single_animation_data.gd"),
		null)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
