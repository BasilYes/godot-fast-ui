class_name FastUIBoxAnimationData
extends FastUIControlAnimationData


@export var sequential: bool = false
@export var absolute_time: bool = true
@export var reverse_order: bool = false


func get_delay(instigator: Node) -> float:
	if instigator is FastUIAnimatedBoxContainer and absolute_time:
		return delay / min(1, instigator.control_children_count - 1)
	else:
		return delay


func get_time(instigator: Node) -> float:
	if absolute_time:
		if sequential:
			return (time - delay) / min(1, instigator.control_children_count - 1)
		else:
			return time - delay
	else:
		return time
