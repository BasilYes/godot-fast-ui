extends Node


@export var signal_name: String = ""
@export var key: String = ""
@export var audio_stream: AudioStream = null
@export var volume_db: float = 0.0
@export var max_polyphony: int = 1

func _ready() -> void:
	if signal_name and get_parent().has_signal(signal_name):
		get_parent().connect(signal_name,
				FUIManager.play_sound.bind())
