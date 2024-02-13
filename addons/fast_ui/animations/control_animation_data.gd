@tool
class_name FastUIControlAnimationData
extends FastUISingleAnimationData


func _init() -> void:
	if not Engine.is_editor_hint() or _tracks:
		return
	_tracks = [
		FastUIRelativePropertyTrack.new()
	]
	_tracks[0]._name = "position"
	_tracks[0]._values = {
		"delta": Vector2.ZERO
	}
