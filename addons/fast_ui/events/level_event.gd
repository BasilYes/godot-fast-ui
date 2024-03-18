class_name FastUILevelEvent
extends FastUIEvent

@export_file("*.tscn") var level: String = ""

func trigger(instigator: Node) -> void:
	if level:
		var transition: = instigator.get_tree().root.get_node_or_null("LvlTransitions")
		if transition:
			transition.swap_level(level)
		else:
			instigator.get_tree().change_scene_to_file(level)
