class_name FastUILevelTrigger
extends FastUITrigger

@export_file("*.tscn") var level: String = ""

func trigger(instigator: Node) -> void:
	if level:
		if Engine.has_singleton("Transactions"):
			var transactions: = Engine.get_singleton("Transactions")
			Transactions.swap_level(level)
		else:
			instigator.get_tree().change_scene_to_file(level)
