class_name FastUIAnimationEvent
extends FastUIEvent

@export_node_path(
	"AnimationPlayer",
	"FastUIAnimatedBoxContainer",
	"FastUIAnimatedNode",
) var animation_player: NodePath
@export var animation_id: int = -1
@export var animation_name: String = ""
@export var await_for_end: bool = true

func trigger(instigator: Node) -> void:
	var player: Node = instigator.get_node_or_null(animation_player)
	if player is AnimationPlayer:
		player.has_animation(animation_name)
		player.play(animation_name)
		if await_for_end:
			await player.animation_finished
	else:
		if player.has_method("play_animation_by_id"):
			if await_for_end:
				await player.play_animation_by_id(animation_id)
			else:
				player.play_animation_by_id(animation_id)
