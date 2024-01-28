class_name FastUIAnimatedBoxContainer
extends BoxContainer

signal animation_finished

@export var play_on_start: int = -1
@export var animations: Array[FastUIBoxAnimationData] = []
var active_animation: FastUIBoxAnimationData = null
var animation_progress: Array[float] = []


func _ready() -> void:
	play_animation_by_id(play_on_start)


func play_animation_by_id(animation_id: int) -> void:
	if animation_id >= animations.size() or animation_id < 0:
		return
	await play_animation(animations[animation_id])


func play_animation(animation: FastUIBoxAnimationData) -> void:
	if not animation:
		return
	if active_animation:
		return
	active_animation = animation
	var control_children_count: int = 0
	for i in get_children():
		if i is Control and i.visible:
			control_children_count += 1
	var abs_delay: float = animation.get_abs_delay(control_children_count)
	var abs_time: float = animation.get_abs_time(control_children_count)
	animation_progress.resize(control_children_count)
	for i in animation_progress.size():
		animation_progress[i] = float(animation.reverse)
	var tween: Tween
	var counter: int = 0
	for i in get_children():
		if i is Control and i.visible:
			if counter:
				if animation.sequential:
					await tween.finished
				await get_tree().create_timer(abs_delay).timeout
			tween = get_tree().create_tween()
			tween.set_trans(animation.tween_transition_type)
			tween.set_ease(animation.tween_ease_type)
			tween.tween_method(
				_update_shift.bind(counter),
				float(animation.reverse),
				float(not animation.reverse),
				abs_time
			)
			counter += 1
	await tween.finished
	active_animation = null
	animation_finished.emit()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			if not active_animation:
				return
			var counter: int = 0
			for i in get_children():
				if i is Control and i.visible:
					var rect: Rect2 = i.get_rect()
					rect.position += active_animation.delta_position * animation_progress[counter]
					fit_child_in_rect(i, rect)
					counter += 1


func _update_shift(new_shift: float, child_id: int) -> void:
	animation_progress[child_id] = new_shift
	notification(NOTIFICATION_SORT_CHILDREN)
