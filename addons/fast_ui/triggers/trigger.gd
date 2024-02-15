class_name FastUITrigger
extends Resource

@export var _events: Array[FastUIEvent]
@export var _lock: FastUITriggerLock = null

func init(owner: Node) -> void:
	pass

func _execute(target: Node) -> void:
	if _lock:
		if _lock.locked:
			return
		else:
			_lock.locked = true
	for i in _events:
		if i:
			await i.trigger(target)
	if _lock:
		_lock.locked = false
