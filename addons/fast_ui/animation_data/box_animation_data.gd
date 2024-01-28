class_name FastUIBoxAnimationData
extends FastUIAnimationData


@export var sequential: bool = false
@export var absolute_time: bool = true
@export var time: float = 1.0
@export var delay: float = 0.4
@export var delta_position: Vector2
@export var reverse: bool
@export var tween_transition_type: Tween.TransitionType 
@export var tween_ease_type: Tween.EaseType


func get_abs_delay(children_count: int) -> float:
	if absolute_time:
		return delay / min(1, children_count - 1)
	else:
		return delay


func get_abs_time(children_count: int) -> float:
	return time if absolute_time else time - delay
