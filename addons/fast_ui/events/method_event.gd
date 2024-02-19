class_name FastUIMethodEvent
extends FastUIEvent

@export var _method_name: StringName
@export var _args: Array = []
@export var _target_path: NodePath

func trigger(target: Node) -> void:
	if target:
		if _target_path:
			var _target := target.get_node(_target_path)
			if _target:
				_target.callv(_method_name, _args)
				return
		target.callv(_method_name, _args)
