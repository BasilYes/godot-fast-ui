@tool
class_name FastUIContainerAnimationData
extends FastUISingleAnimationData


func _init() -> void:
	if not Engine.is_editor_hint() or _tracks:
		return
	_tracks = [
		FastUIRelativePropertyTrack.new(),
		FastUIPropertyTrack.new()
	]
	_tracks[0]._name = "position"
	_tracks[0]._values = {
		"delta": Vector2.ZERO
	}
	_tracks[1]._name = "modulate"
	_tracks[1]._values = {
		"start": Color.WHITE,
		"end": Color(Color.WHITE, 0.0)
	}
