class_name FastUIAnimatedNode
extends Node

signal animation_finished

@export var play_on_start: int = -1
@export var animations: Array[FastUISingleAnimationData] = []

var active_animation: FastUISingleAnimationData = null


func _ready() -> void:
	play_animation_by_id(play_on_start)


func play_animation_by_id(animation_id: int) -> void:
	if animation_id >= animations.size() or animation_id < 0:
		return
	await play_animation(animations[animation_id])


func play_animation(animation: FastUISingleAnimationData) -> void:
	if not animation:
		return
	if active_animation:
		return
	active_animation = animation
	await animation.play(self)
	active_animation = null
	animation_finished.emit()
