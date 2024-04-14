class_name FastUITriggerableNode
extends Node

@export var _triggers: Array[FastUITrigger]

func _ready() -> void:
	for t in _triggers:
		if t:
			t.init(self)
