extends BaseButton

@export var triggers: Array[FastUITrigger] = []

func _ready() -> void:
	pressed.connect(func():
		for i in triggers:
			if i:
				await i.trigger(self)
	)
