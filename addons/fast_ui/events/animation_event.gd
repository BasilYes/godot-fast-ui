class_name FastUIAnimationEvent
extends FastUIEvent

@export_node_path(
	"AnimationPlayer",
	"FastUIAnimatedNode",
	"FastUIAnimatedContainer",
) var _animation_player: NodePath
@export var _animation_id: int = -1
@export var _animation_name: StringName = ""
@export var _await_for_end: bool = true

func trigger(instigator: Node) -> void:
	var player: Node = instigator.get_node_or_null(_animation_player)
	if not player:
		return
	if player is AnimationPlayer:
		player.has_animation(_animation_name)
		player.play(_animation_name)
		if _await_for_end:
			await player.animation_finished
	else:
		if player.has_method("play_animation_by_id"):
			if _await_for_end:
				await player.play_animation_by_id(_animation_id)
			else:
				player.play_animation_by_id(_animation_id)
