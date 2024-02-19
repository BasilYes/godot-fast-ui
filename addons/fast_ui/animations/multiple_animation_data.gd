class_name FastUIMultipleAnimationData
extends FastUISingleAnimationData


@export var in_viewports: bool = false

@export var _delay: float = 0.4
@export var sequential: bool = false
@export var absolute_time: bool = true
@export var _reverse_order: bool = false

const PROGRESS_META: String = "animation_progress"

func play(instigator: Node) -> void:
	var child_count: int = instigator.get_child_count()
	var abs_delay: float = get_delay(instigator)
	var abs_time: float = get_time(instigator)
	var instigator_children: Array[Node] = instigator.get_children()
	if _reverse_order:
		instigator_children.reverse()
	for i in instigator_children:
		i.set_meta(PROGRESS_META, 0.0)
		for p in _tracks:
			p._start(i)
			p._process(float(_reverse), i)
	var tween: Tween
	for i in instigator_children:
		if tween:
			if sequential:
				await tween.finished
			if abs_delay:
				await instigator.get_tree().create_timer(abs_delay).timeout
		if not i:
			continue
		i.set_meta("animation_reverse", _reverse)
		tween = i.create_tween()
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
				_update_tracks.bind(i),
				0.0,
				1.0,
				abs_time)
	await tween.finished
	for i in instigator_children:
		i.remove_meta(PROGRESS_META)
		for p in _tracks:
			p._end(i)
			i.remove_meta("animation_reverse")


func _update_tracks(progress: float, instigator: Node) -> void:
	if instigator.get_meta("animation_reverse"):
		progress = 1.0 - progress
	for i in _tracks:
		i._process(progress, instigator)


func get_delay(instigator: Node) -> float:
	if instigator and absolute_time:
		return _delay / max(1, instigator.get_child_count() - 1)
	else:
		return _delay


func get_time(instigator: Node) -> float:
	if absolute_time:
		if instigator and sequential:
			return (_time - _delay) / max(1, instigator.get_child_count() - 1)
		else:
			return _time - _delay
	else:
		return _time
