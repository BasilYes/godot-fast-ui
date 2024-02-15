@tool
extends FastUITriggerableNode

func _init() -> void:
	if not Engine.is_editor_hint() or _triggers:
		return
	_triggers = [
		FastUISignalTrigger.new()
	]
	_triggers[0]._lock = preload("res://addons/fast_ui/triggers/ui_trigger_lock.tres")
	_triggers[0]._signal_name = "pressed"
