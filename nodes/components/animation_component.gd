@tool
class_name FUIAnimationComponent
extends Node

enum Anchers {
	TOP_LEFT,
	TOP,
	TOP_RIGHT,
	LEFT,
	CENTER,
	RIGHT,
	BOTTOM_LEFT,
	BOTTOM,
	BOTTOM_RIGHT
}

const ALLOWED_TYPES: = [
	Variant.Type.TYPE_FLOAT,
	Variant.Type.TYPE_VECTOR2,
	Variant.Type.TYPE_VECTOR3,
	Variant.Type.TYPE_VECTOR4,
	Variant.Type.TYPE_RECT2,
	Variant.Type.TYPE_TRANSFORM2D,
	Variant.Type.TYPE_PLANE,
	Variant.Type.TYPE_QUATERNION,
	Variant.Type.TYPE_AABB,
	Variant.Type.TYPE_BASIS,
	Variant.Type.TYPE_TRANSFORM3D,
	Variant.Type.TYPE_PROJECTION,
	Variant.Type.TYPE_COLOR
]

var value_name: String = "scale" :
	set(value):
		value_name = value
		if get_parent() and value_name in get_parent():
			value_type = typeof(get_parent().get(value_name))
var value_type: Variant.Type = Variant.Type.TYPE_VECTOR2 :
	set(value):
		value_type = value
		notify_property_list_changed()
var anchor: Anchers = Anchers.CENTER
@export var duration: float = 0.2
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN

var value: Variant = Vector2(1.1, 1.1)

var target: Control
var default_value: Variant
var tween: Tween

func _get_property_list() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if get_parent() is Control:
		out.append({
			"name": "anchor",
			"type": Variant.Type.TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": Anchers.keys().reduce(func(a: Variant, b: Variant) -> String:
				return a + "," + b),
			"usage": PROPERTY_USAGE_DEFAULT
		})
	out.append({
		"name": "value_name",
		"type": Variant.Type.TYPE_STRING_NAME,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": get_parent().get_property_list().reduce(func(a: Variant, b: Variant) -> String:
			if b.type not in ALLOWED_TYPES or not (b.usage & PROPERTY_USAGE_EDITOR):
				b = ""
			else:
				b = b.name
			if a is Dictionary:
				if a.type not in ALLOWED_TYPES or not (a.usage & PROPERTY_USAGE_EDITOR):
					a = ""
				else:
					a = a.name
			if a == "":
				if b == "":
					return ""
				return b
			else:
				if b == "":
					return a
				return a + "," + b
			return ""),
		"usage": PROPERTY_USAGE_DEFAULT
	})
	out.append({
		"name": "value",
		"type": value_type,
		"usage": PROPERTY_USAGE_DEFAULT
	})
	return out

func _ready() -> void:
	target = get_parent()
	if Engine.is_editor_hint():
		return
	if value_name in target:
		_setup.call_deferred()

func _setup() -> void:
	default_value = target.get(value_name)

func setup_ancher(immidiate: bool = true, speed: float = 1.0) -> void:
	if not target is Control:
		return
	if not (value_name == "scale" or value_name == "rotation"):
		return
	var pivot_offset: Vector2
	match anchor:
		Anchers.TOP_LEFT:
			pivot_offset = Vector2(0, 0)
		Anchers.TOP:
			pivot_offset = Vector2(0.5, 0) * target.size
		Anchers.TOP_RIGHT:
			pivot_offset = Vector2(1, 0) * target.size
		Anchers.LEFT:
			pivot_offset = Vector2(0, 0.5) * target.size
		Anchers.CENTER:
			pivot_offset = Vector2(0.5, 0.5) * target.size
		Anchers.RIGHT:
			pivot_offset = Vector2(1, 0.5) * target.size
		Anchers.BOTTOM_LEFT:
			pivot_offset = Vector2(0, 1) * target.size
		Anchers.BOTTOM:
			pivot_offset = Vector2(0.5, 1) * target.size
		Anchers.BOTTOM_RIGHT:
			pivot_offset = Vector2(1, 1) * target.size
	if not immidiate and tween and tween.is_valid():
		tween.tween_property(target,
				"pivot_offset",
				pivot_offset,
				duration / speed
		)
	else:
		target.pivot_offset = pivot_offset

func play(speed: float = 1.0, from_end: bool = false, override: bool = true) -> void:
	if target.get(value_name) == (default_value if from_end else value):
		return
	var meta_name: String = "fui_animation_"+value_name
	if target.has_meta(meta_name):
		if override or target.get_meta(meta_name) == self:
			target.get_meta(meta_name).stop(true)
		else:
			return
	tween = create_tween()
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.set_parallel(true)
	tween.tween_property(target,
			value_name,
			default_value if from_end else value,
			duration / speed
	)
	setup_ancher(from_end or target.get(value_name) == default_value, speed)
	target.set_meta(meta_name, self)

func stop(keep_state: bool = false) -> void:
	if not keep_state:
		target.set(value_name, default_value)
	if tween and tween.is_running():
		tween.kill()
		tween = null
