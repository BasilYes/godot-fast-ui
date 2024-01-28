extends BaseButton

@export var triggers: Array[FastUITrigger] = []

func _ready() -> void:
	pressed.connect(func():
		for i in triggers:
			await i.trigger(self)
	)
