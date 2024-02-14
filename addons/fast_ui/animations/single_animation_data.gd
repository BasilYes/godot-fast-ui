class_name FastUISingleAnimationData
extends FastUIAnimationData


enum LoopType {
	NO_LOOP,
	LOOP,
	PING_PONG
}

@export var _tracks: Array[FastUITrack]
@export var _time: float = 1.0
@export var _tween_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var _tween_ease_type: Tween.EaseType = Tween.EASE_IN
@export var _loop: LoopType = LoopType.NO_LOOP

var _reverse: bool = false

func play(instigator: Node) -> void:
	for i in _tracks:
		i._start(instigator)
		i._process(float(_reverse), instigator)
	instigator.set_meta("animation_reverse", _reverse)
	var tween: Tween
	tween = instigator.get_tree().create_tween()
	tween.set_trans(_tween_transition_type)
	tween.set_ease(_tween_ease_type)
	match _loop:
		LoopType.LOOP:
			tween.set_loops()
		LoopType.PING_PONG:
			tween.set_loops()
			tween.loop_finished.connect(func(loop_count: int):
				instigator.set_meta(
					"animation_reverse",
					(loop_count + int(_reverse)) % 2 )
			)
	tween.tween_method(
			_update_tracks.bind(instigator),
			0.0,
			1.0,
			_time)
	await tween.finished
	instigator.remove_meta("animation_reverse")
	for i in _tracks:
		i._end(instigator)


func _update_tracks(progress: float, instigator: Node) -> void:
	if instigator.get_meta("animation_reverse"):
		progress = 1.0 - progress
	for i in _tracks:
		i._process(progress, instigator)
