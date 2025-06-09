@tool
class_name FUIComponent
extends Node

enum Action {
	OPEN_SCREEN = 0,
	PREVIOUS_SCREEN = 1,
	CLOSE_SCREEN = 2,
}

@export var instigator: Node :
	set(value):
		instigator = value
		if not Engine.is_editor_hint():
			return
		notify_property_list_changed()

var action: Action = Action.OPEN_SCREEN :
	set(value):
		action = value
		if not Engine.is_editor_hint():
			return
		notify_property_list_changed()
var path: String = "" :
	set(value):
		path = value
		if path.begins_with("uid://"):
			key = ResourceUID.get_id_path(
				ResourceUID.text_to_id(path)
			).get_file().get_basename()
		else:
			key = path.get_file().get_basename()
var signal_name: String = "ready"
var key: String = ""
var on_top: bool = false
var reversable: bool = false
var all_layers: bool = false
var all_visible: bool = false

func _ready() -> void:
	if not instigator:
		instigator = get_parent()
	if Engine.is_editor_hint():
		return
	if not FUIManager:
		push_warning(get_path(), ": No FUIManager, tree exit")
		queue_free()
		return
	if not instigator.has_signal(signal_name):
		push_warning(get_path(), ": No signal named \"%s\" on instigator, tree exit" % [signal_name])
		queue_free()
		return
	match action:
		Action.OPEN_SCREEN:
			instigator.connect(signal_name, func(
					_a1: Variant = null,
					_a2: Variant = null,
					_a3: Variant = null,
					_a4: Variant = null,
					_a5: Variant = null,
				) -> void:		
					FUIManager.open_screen(
						# TODO: allow to preload scene
						key, null, path, on_top, reversable)
			)
		Action.CLOSE_SCREEN:
			instigator.connect(signal_name, func(
					_a1: Variant = null,
					_a2: Variant = null,
					_a3: Variant = null,
					_a4: Variant = null,
					_a5: Variant = null,
				) -> void:		
					FUIManager.close_screen(
						key, reversable, all_visible)
			)
		Action.PREVIOUS_SCREEN:
			instigator.connect(signal_name, func(
					_a1: Variant = null,
					_a2: Variant = null,
					_a3: Variant = null,
					_a4: Variant = null,
					_a5: Variant = null,
				) -> void:
					FUIManager.previous_screen(all_layers)
			)


func _get_property_list() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if instigator:
		result.append({
			"name": "signal_name",
			"type": Variant.Type.TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": instigator.get_signal_list().reduce(func(a: Variant, b: Dictionary) -> String:
				if a is Dictionary:
					return a.name + "," + b.name
				return a + "," + b.name),
			"usage": PROPERTY_USAGE_DEFAULT
		})
	result.append({
		"name": "action",
		"type": Variant.Type.TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Open Screen:0,Previous Screen:1,Close Screen:2",
	})
	match action:
		Action.OPEN_SCREEN:
			result.append({
				"name": "path",
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_FILE,
				"hint_string": "*.tscn,*.scn",
			})
			result.append({
				"name": "key",
				"type": TYPE_STRING,
			})
			result.append({
				"name": "on_top",
				"type": TYPE_BOOL,
		})
			result.append({
				"name": "reversable",
				"type": TYPE_BOOL,
			})
		Action.PREVIOUS_SCREEN:
			result.append({
				"name": "all_layers",
				"type": TYPE_BOOL,
			})
		Action.CLOSE_SCREEN:
			result.append({
				"name": "key",
				"type": TYPE_STRING,
			})
			result.append({
				"name": "reversable",
				"type": TYPE_BOOL,
			})
			result.append({
				"name": "all_visible",
				"type": TYPE_BOOL,
			})
	return result
