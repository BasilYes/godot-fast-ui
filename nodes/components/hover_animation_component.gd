@tool
class_name FastUIHoverAnimationComponent
extends FastUIAnimationComponent

var is_hovered: bool = false

func _setup() -> void:
	super()
	if not target is Control:
		return
	connect_singnals()
	setup_ancher()

func connect_singnals() -> void:
	target.focus_entered.connect(_focus_entered)
	target.focus_exited.connect(_focus_exited)
	target.mouse_entered.connect(_mouse_entered)
	target.mouse_exited.connect(_mouse_exited)
	if target is Button:
		target.button_up.connect(func() -> void:
			if is_hovered:
				play(1.0, false, true)
			else:
				play(1.0, true, true)
		)
	else:
		target.gui_input.connect(_gui_input)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if is_hovered:
			play(1.0, false, true)
		else:
			play(1.0, true, true)

func _focus_entered() -> void:
	pass

func _focus_exited() -> void:
	pass

func _mouse_entered() -> void:
	is_hovered = true
	play(1.0, false, true)

func _mouse_exited() -> void:
	is_hovered = false
	play(1.0, true, true)
