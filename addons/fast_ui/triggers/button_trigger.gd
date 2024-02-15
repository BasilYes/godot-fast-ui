@tool
class_name FastUIButtonTrigger
extends FastUISignalTrigger


func _init() -> void:
	if not Engine.is_editor_hint() or _lock:
		return
	_lock = preload("res://addons/fast_ui/triggers/ui_trigger_lock.tres")
	_signal_name = "pressed"
