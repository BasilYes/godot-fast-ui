class_name FastUILevelEvent
extends FastUIEvent

@export_file("*.tscn") var level: String = ""

func trigger(instigator: Node) -> void:
	if level:
		var transactions: = instigator.get_tree().root.get_node_or_null("Transactions")
		if transactions:
			Transactions.swap_level(level)
		else:
			instigator.get_tree().change_scene_to_file(level)
