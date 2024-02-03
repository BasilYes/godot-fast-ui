class_name FastUIAnimatedControl
extends Control

signal animation_finished

@export var play_on_start: int = -1
@export var animations: Array[FastUIControlAnimationData] = []

var active_animation: FastUIControlAnimationData = null
var animation_progress: float = 0
var start_position: Vector2


func _ready() -> void:
	play_animation_by_id(play_on_start)
	start_position = position
	visibility_changed.connect(func():
		if not visible:
			position = start_position
		)


func play_animation_by_id(animation_id: int) -> void:
	if animation_id >= animations.size() or animation_id < 0:
		return
	await play_animation(animations[animation_id])


func play_animation(animation: FastUIControlAnimationData) -> void:
	if not animation:
		return
	if active_animation:
		return
	active_animation = animation
	var abs_delay: float = animation.get_delay(self)
	var abs_time: float = animation.get_time(self)
	animation_progress = 0
	_update_shift(0.0)
	var tween: Tween
	if abs_delay:
		await get_tree().create_timer(abs_delay).timeout
	tween = get_tree().create_tween()
	tween.set_trans(animation.tween_transition_type)
	tween.set_ease(animation.tween_ease_type)
	tween.tween_method(
		_update_shift,
		0.0,
		1.0,
		abs_time
	)
	await tween.finished
	active_animation = null
	animation_finished.emit()


func _update_shift(new_shift: float) -> void:
	animation_progress = new_shift
	position = start_position + active_animation.get_end_position(self) * animation_progress\
			+ active_animation.get_start_position(self) * (1.0 - animation_progress)
