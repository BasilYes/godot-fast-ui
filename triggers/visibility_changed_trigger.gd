class_name FastUIVisibilityChangedTrigger
extends FastUITrigger

enum CallOn {
	VISIBLE = 0,
	HIDDEN = 1,
	ANYCHANGE = 2
}

@export var call_on: CallOn = CallOn.VISIBLE

func init(owner: Node) -> void:
	if not owner is Control:
		push_error("Visibility change triiger work only for control, ", owner.get_path(), " is not Control")
		return
	owner.visibility_changed.connect(func() -> void:
			match call_on:
				CallOn.VISIBLE:
					if owner.visible:
						_execute(owner)
				CallOn.HIDDEN:
					if not owner.visible:
						_execute(owner)
				CallOn.ANYCHANGE:
					_execute(owner)
	)
