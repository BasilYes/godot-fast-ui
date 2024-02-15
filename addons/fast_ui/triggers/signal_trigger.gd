class_name FastUISignalTrigger
extends FastUITrigger

@export var _signal_name: String
@export var _target_from_signal: bool = false

func init(owner: Node) -> void:
	owner.connect(_signal_name, func(arg1 = null, arg2 = null, arg3 = null, arg4 = null, arg5 = null):
		if _target_from_signal:
			var args = []
			for argument in [arg1, arg2, arg3, arg4, arg5]:
				if argument is Node:
					_execute(argument)
					return
		_execute(owner))
