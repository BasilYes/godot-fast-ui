@tool
extends FastUITriggerableNode

func _init() -> void:
	if not Engine.is_editor_hint() or _triggers:
		return
	_triggers = [
		FastUIVisibilityChangedTrigger.new(),
		FastUIVisibilityChangedTrigger.new()
	]
	_triggers[0].call_on = FastUIVisibilityChangedTrigger.CallOn.VISIBLE
	_triggers[1].call_on = FastUIVisibilityChangedTrigger.CallOn.HIDDEN


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
