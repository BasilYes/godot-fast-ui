class_name FastUIPropertyEvent
extends FastUIEvent

@export var _property_name: StringName
@export var _property: Array = [null]
@export var _target_path: NodePath

func trigger(target: Node) -> void:
	if _property and target:
		if _target_path:
			var _target := target.get_node_or_null(_target_path)
			if _target:
				_target.set(_property_name, _property[0])
				return
			else:
				push_warning(
					"Can't find "
					+ str(_target_path)
					+ " relative to "
					+ str(target.get_path())
				)
		target.set(_property_name, _property[0])

