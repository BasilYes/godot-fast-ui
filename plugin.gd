@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"AnimatedControl"
		,"Control",
		preload("nodes/animated_node.gd"),
		null)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
