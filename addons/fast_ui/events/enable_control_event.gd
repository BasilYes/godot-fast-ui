class_name FastUIEnableControlEvent
extends FastUIEvent

@export_node_path("Control") var node: NodePath
@export var enable: bool

func trigger(instigator: Node) -> void:
	var target: Node = instigator.get_node_or_null(node)
	if enable:
		target.visible = true
		target.set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		target.visible = false
		target.set_process_mode(Node.PROCESS_MODE_DISABLED)
