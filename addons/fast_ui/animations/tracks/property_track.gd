class_name FastUIPropertyTrack
extends FastUITrack


@export var _name: String
@export var _values: Dictionary = {
	"start": 0.0,
	"end": 0.0
}
@export var _reset_on_end: bool = true


func _end(instigator: Node) -> void:
	if _reset_on_end:
		instigator.set(_name, _values.start)

func _process(progress: float, instigator: Node) -> void:
	instigator.set(
			_name,
			_values.start + (_values.end - _values.start) * progress
		)
