class_name FastUIRelativePropertyTrack
extends FastUIAnimatedPropertyData

@export var _name: String
@export var _values: Dictionary = {
	"delta": 0
}
@export var _reset_on_end: bool = true

func _start(instigator: Node) -> void:
	instigator.set_meta(_name+"_start_animation", instigator.get(_name))

func _end(instigator: Node) -> void:
	if _reset_on_end:
		instigator.set(_name, instigator.get_meta(_name+"_start_animation"))
	instigator.remove_meta(_name+"_start_animation")

func _process(progress: float, instigator: Node) -> void:
	instigator.set(
			_name,
			instigator.get_meta(_name+"_start_animation") + _values.delta * progress
		)
