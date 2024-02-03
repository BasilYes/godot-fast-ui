class_name FastUIControlAnimationData
extends FastUIAnimationData

@export var time: float = 1.0
@export var delay: float = 0.4
@export var in_viewports: bool = false
@export var delta_position: Vector2 = Vector2.ZERO
@export var reverse: bool = false
@export var tween_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var tween_ease_type: Tween.EaseType = Tween.EASE_IN


func get_end_position(instigator: Node) -> Vector2:
	if reverse:
		return Vector2.ZERO
	else:
		if in_viewports:
			return instigator.get_viewport_rect().size * delta_position
		else:
			return delta_position


func get_start_position(instigator: Node) -> Vector2:
	if reverse:
		if in_viewports:
			return instigator.get_viewport_rect().size * delta_position
		else:
			return delta_position
	else:
		return Vector2.ZERO


func get_delay(instigator: Node) -> float:
	return delay


func get_time(instigator: Node) -> float:
	return time

