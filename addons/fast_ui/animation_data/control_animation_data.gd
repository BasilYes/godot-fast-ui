@tool
class_name FastUIControlAnimationData
extends FastUIAnimationData


enum LoopType {
	NO_LOOP,
	LOOP,
	PING_PONG
}

@export var delay: float = 0.4
@export var in_viewports: bool = false
@export var delta_position: Vector2 = Vector2.ZERO

@export var _properties: Array[FastUIAnimatedPropertyData]
@export var time: float = 1.0
@export var _reverse: bool = false
@export var tween_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var tween_ease_type: Tween.EaseType = Tween.EASE_IN
@export var _loop: LoopType = LoopType.NO_LOOP


func _init() -> void:
	if not Engine.is_editor_hint() or _properties:
		return
	_properties = [
		FastUIRelativeAnimatedPropertyData.new()
	]
	_properties[0]._name = "position"
	_properties[0]._values = {
		"delta": Vector2.ZERO
	}

func play(instigator: Node) -> void:
	for i in _properties:
		i._start(instigator)
	var tween: Tween
	tween = instigator.get_tree().create_tween()
	tween.set_trans(tween_transition_type)
	tween.set_ease(tween_ease_type)
	match _loop:
		LoopType.LOOP:
			tween.set_loops()
		LoopType.PING_PONG:
			tween.set_loops()
			tween.loop_finished.connect(func():
				_reverse = not _reverse
			)
	tween.tween_method(
		_update_properties.bind(instigator),
		0.0,
		1.0,
		time
	)
	await tween.finished
	for i in _properties:
		i._end(instigator)


func _update_properties(progress: float, instigator: Node) -> void:
	if _reverse:
		progress = 1.0 - progress
	for i in _properties:
		i._process(progress, instigator)


func get_end_position(instigator: Node) -> Vector2:
	if _reverse:
		return Vector2.ZERO
	else:
		if in_viewports:
			return instigator.get_viewport_rect().size * delta_position
		else:
			return delta_position


func get_start_position(instigator: Node) -> Vector2:
	if _reverse:
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

