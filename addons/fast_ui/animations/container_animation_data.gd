@tool
class_name FastUIContainerAnimationData
extends FastUIMultipleAnimationData


func _init() -> void:
	if not Engine.is_editor_hint() or _tracks:
		return
	_tracks = [
		FastUIMetaTrack.new(),
		FastUIPropertyTrack.new()
	]
	_tracks[0]._name = "delta_position"
	_tracks[0]._values = {
		"start": Vector2.ZERO,
		"end": Vector2.ZERO
	}
	_tracks[1]._name = "modulate"
	_tracks[1]._values = {
		"start": Color.WHITE,
		"end": Color(Color.WHITE, 0.0)
	}
