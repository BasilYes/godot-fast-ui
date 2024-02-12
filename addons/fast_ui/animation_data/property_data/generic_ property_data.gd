class_name FastUIGenericAnimatedPropertyData
extends FastUIAnimatedPropertyData


@export var _name: String
@export var _values: Dictionary = {
	"start": 0,
	"end": 0
}

func _process(progress: float, instigator: Node) -> void:
	instigator.set(
			_name,
			_values.start + (_values.end - _values.start) * progress
		)
