class_name FustUIButton
extends BaseButton

@export var triggers: Array[FastUITrigger] = []

static var process_triggers: bool = false

func _ready() -> void:
	pressed.connect(func():
		if FustUIButton.process_triggers:
			return
		FustUIButton.process_triggers = true
		for i in triggers:
			if i:
				await i.trigger(self)
		FustUIButton.process_triggers = false
	)
