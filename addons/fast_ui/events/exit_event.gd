class_name FastUIExitEvent
extends FastUIEvent


func trigger(instigator: Node) -> void:
	instigator.get_tree().quit()
