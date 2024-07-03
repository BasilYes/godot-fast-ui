@tool
class_name FastUISimplifiedTabContainer
extends Container

@export var current_tab: int = 0 :
	set(value):
		value = max(min(get_child_count() - 1, value), 0)
		if current_tab == value:
			return
		current_tab = value
		_update_children_visibility()


func _ready() -> void:
	for i in get_children():
		if i is Control:
			i.visibility_changed.connect(_child_visibility_changed)
	child_entered_tree.connect(func(node: Node) -> void:
			if node is Control:
				node.visibility_changed.connect(_child_visibility_changed)
	)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			for i in get_children():
				if i is Control:
					fit_child_in_rect(i, Rect2(Vector2.ZERO, size))


func _update_children_visibility() -> void:
	for i in get_child_count():
		var child: Node = get_child(i)
		if child is Control:
			if i == current_tab:
				if not child.visible:
					child.visible = true
			else:
				if child.visible:
					child.visible = false


func _child_visibility_changed() -> void:
	print("child visible changed")
	var unlegal_visible: int = current_tab
	for i in get_child_count():
		var child: Node = get_child(i)
		if child is Control and i != current_tab and child.visible:
				unlegal_visible = i
	current_tab = unlegal_visible