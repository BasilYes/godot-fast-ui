@tool
class_name FastUIAnimationComponent
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

@export var value_name: String = "scale"
@export var value_type: Variant.Type = Variant.Type.TYPE_VECTOR2 :
	set(value):
		value_type = value
		notify_property_list_changed()
@export var duration: float = 0.2
@export var anchor: Anchers = Anchers.CENTER
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN

var value: Variant = Vector2(1.1, 1.1)

var target: Control
var default_value: Variant
var tween: Tween

func _get_property_list() -> Array[Dictionary]:
	return [
		{
			"name": "value",
			"type": value_type,
			"usage": PROPERTY_USAGE_DEFAULT
		}
	]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	target = get_parent()
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
