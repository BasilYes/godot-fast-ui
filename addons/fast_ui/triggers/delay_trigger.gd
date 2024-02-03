class_name FastUIDelayTrigger
extends FastUITrigger

@export var time: float = 1.0

func trigger(instigator: Node) -> void:
	await instigator.get_tree().create_timer(time).timeout
