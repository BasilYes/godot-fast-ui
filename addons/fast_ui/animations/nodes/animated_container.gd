class_name FastUIAnimatedBoxContainer
extends Container

signal animation_finished

@export var play_on_start: int = -1
@export var animations: Array[FastUIBoxAnimationData] = []


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
	set_process(true)
	await animation.play(self)
	notification(NOTIFICATION_SORT_CHILDREN)
	set_process(false)
	animation_finished.emit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		for i in get_children():
			if i is Control and i.visible and i.has_meta("delta_position"):
				var rect: Rect2 = i.get_rect()
				rect.position += i.get_meta("delta_position")
				fit_child_in_rect(i, rect)
