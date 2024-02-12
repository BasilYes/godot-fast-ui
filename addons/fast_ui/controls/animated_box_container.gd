class_name FastUIAnimatedBoxContainer
extends BoxContainer

signal animation_finished

@export var play_on_start: int = -1
@export var animations: Array[FastUIBoxAnimationData] = []

var control_children_count: int = 0
var active_animation: FastUIBoxAnimationData = null
var animation_progress: Array[float] = []


func _ready() -> void:
	set_process(false)
	play_animation_by_id(play_on_start)


func _process(delta: float) -> void:
	notification(NOTIFICATION_SORT_CHILDREN)


func play_animation_by_id(animation_id: int) -> void:
	if animation_id >= animations.size() or animation_id < 0:
		return
	await play_animation(animations[animation_id])


func play_animation(animation: FastUIBoxAnimationData) -> void:
	if not animation:
		return
	while active_animation:
		await animation_finished
	set_process(true)
	active_animation = animation
	control_children_count = 0
	for i in get_children():
		if i is Control and i.visible:
			control_children_count += 1
	var abs_delay: float = animation.get_delay(self)
	var abs_time: float = animation.get_time(self)
	animation_progress = []
	animation_progress.resize(control_children_count)
	var tween: Tween
	var counter: int = 0
	var children: Array[Node] = get_children()
	for i in get_children():
		if i is Control and i.visible:
			if counter:
				if animation.sequential:
					await tween.finished
				if abs_delay:
					await get_tree().create_timer(abs_delay).timeout
			tween = get_tree().create_tween()
			tween.set_trans(animation.tween_transition_type)
			tween.set_ease(animation.tween_ease_type)
			tween.tween_method(
				_update_shift.bind(counter),
				0.0,
				1.0,
				abs_time
			)
			counter += 1
	await tween.finished
	notification(NOTIFICATION_SORT_CHILDREN)
	set_process(false)
	active_animation = null
	animation_finished.emit()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			if not active_animation:
				return
			var counter: int = 0
			if active_animation.reverse_order:
				counter = animation_progress.size() - 1
			for i in get_children():
				if i is Control and i.visible:
					var rect: Rect2 = i.get_rect()
					rect.position += active_animation.get_end_position(self) * animation_progress[counter]\
							+ active_animation.get_start_position(self) * (1.0 - animation_progress[counter])
					fit_child_in_rect(i, rect)
					if active_animation.reverse_order:
						counter -= 1
					else:
						counter += 1


func _update_shift(new_shift: float, child_id: int) -> void:
	animation_progress[child_id] = new_shift
