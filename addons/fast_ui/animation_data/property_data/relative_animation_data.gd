class_name FastUIRelativeAnimatedPropertyData
extends FastUIAnimatedPropertyData

@export var _name: String
@export var _values: Dictionary = {
	"delta": 0
}

func _start(instigator: Node) -> void:
	instigator.set_meta(_name+"_start_animation", instigator.get(_name))

func _end(instigator: Node) -> void:
	instigator.remove_meta(_name+"_start_animation")

func _process(progress: float, instigator: Node) -> void:
	instigator.set(
			_name,
			instigator.get_meta(_name+"_start_animation") + _values.delta * progress
		)
