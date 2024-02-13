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
	if active_animation:
		return
	set_process(true)
	active_animation = animation
	await animation.play(self)
	notification(NOTIFICATION_SORT_CHILDREN)
	set_process(false)
	active_animation = null
	animation_finished.emit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		if not active_animation:
			return
		for i in get_children():
			if i is Control and i.visible and i.has_meta("delta_position"):
				var rect: Rect2 = i.get_rect()
				rect.position += i.get_meta("delta_position")
				fit_child_in_rect(i, rect)
