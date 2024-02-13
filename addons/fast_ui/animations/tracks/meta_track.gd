class_name FastUIMetaTrack
extends FastUITrack

@export var _name: String
@export var _values: Dictionary = {
	"start": 0.0,
	"end": 0.0,
}
@export var _clean_on_end: bool = true

func _end(instigator: Node) -> void:
	if _clean_on_end:
		instigator.remove_meta(_name)

func _process(progress: float, instigator: Node) -> void:
	instigator.set_meta(
			_name,
			_values.start + (_values.end - _values.start) * progress
		)
