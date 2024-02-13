@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"AnimatedControl"
		,"Control",
		preload("res://addons/fast_ui/controls/animated_node.gd"),
		null)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
