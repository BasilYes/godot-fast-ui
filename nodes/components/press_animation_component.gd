@tool
class_name FastUIPressAnimationComponent
extends FastUIAnimationComponent

var is_pressed: bool = false

func _setup() -> void:
	super()
	if not target is Control:
		return
	connect_singnals()


func connect_singnals() -> void:
	if target is Button:
		target.button_down.connect(func() -> void:
			is_pressed = true
			play()
		)
		target.button_up.connect(func() -> void:
			is_pressed = false
			play(1.0, true, false)
		)
	else:
		target.gui_input.connect(_gui_input)
	target.mouse_entered.connect(_mouse_entered)

func _mouse_entered() -> void:
	if is_pressed:
		play()
	else:
		play(1.0, true, false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_pressed = true
			play()
		if event.is_released():
			is_pressed = false
			play(1.0, true, false)
