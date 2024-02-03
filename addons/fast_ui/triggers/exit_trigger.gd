class_name FastUIExitTrigger
extends FastUITrigger


func trigger(instigator: Node) -> void:
	instigator.get_tree().quit()
