class_name FUICustomAnimationComponent
extends FUIAnimationComponent



@export var forward_signal_name: String = ""
@export var backward_signal_name: String = ""

func _ready() -> void:
	super()
	if forward_signal_name and target.has_signal(forward_signal_name):
		target.connect(forward_signal_name, play.bind(1.0, false, true))
	if backward_signal_name and target.has_signal(backward_signal_name):
		target.connect(backward_signal_name, play.bind(1.0, true, true))
