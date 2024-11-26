extends Node

@onready var active: CanvasLayer = $Active
@onready var pool: CanvasLayer = $Pool
@onready var sounds: Node = $Sounds

var log: Array = []
var sound_bus: String = "Sound"

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		queue_free()
		return
	var path: String = ProjectSettings.get_setting(
			FUIConsts.INITIAL_PATH_SETTING, ""
	)
	var key: String = ProjectSettings.get_setting(
			FUIConsts.INITIAL_KEY_SETTING, ""
	)
	sound_bus = ProjectSettings.get_setting(FUIConsts.UI_AUDIO_BUS_NAME, "Sound")
	if not path:
		return
	if not key:
		key = "InitialScreen"
	open_screen(key, path)


func play_sound(
		key: String = "",
		audio_stream: AudioStream = null,
		volume_db: float = 0.0,
		max_polyphony: int = 1,
) -> AudioStreamPlayer:
	var sound: AudioStreamPlayer = null
	if key:
		sound = sounds.get_node_or_null(key)
	if not sound:
		sound = AudioStreamPlayer.new()
		sound.volume_db = volume_db
		sound.bus = sound_bus
		sound.stream = audio_stream
		sound.max_polyphony = max_polyphony
		sounds.add_child(sound)
	if not key:
		sound.finished.connect(sound.queue_free)
	else:
		sound.name = key
	sound.play()
	return sound


func open_screen(
		key: String = "",
		path: String = "",
		on_top: bool = false,
		reversable: bool = false
) -> Control:
	if not on_top:
		if reversable:
			if get_child_count():
				log.push_back(active.get_children())
		else:
			log = []
		for i:Node in active.get_children():
			i.reparent(pool)
	var screen: Control = active.get_node_or_null(key)
	if screen:
		push_warning(key, " widget allready on screen")
		return screen
	screen = pool.get_node_or_null(key)
	if screen:
		screen.reparent(active)
		return screen
	if not path:
		return screen
	var scene: PackedScene = load(path)
	if scene:
		screen = load(path).instantiate()
	else:
		push_warning("Scene path is not valid ", path)
		return null
	if key:
		screen.name = key
	active.add_child(screen)
	return screen


func previous_screen(all_layers: bool = false) -> void:
	if all_layers:
		for i:Node in active.get_children():
			i.reparent(pool)
	else:
		var node: Node = active.get_child(0)
		if node:
			node.reparent(pool)
	if active.get_child_count():
		return
	if not log:
		return
	for i:Node in log.pop_back():
		i.reparent(active)


func close_screen(
	key: String,
	reversable: bool = false,
	all_visible: bool = false,
) -> void:
	if all_visible:
		if reversable:
			if get_child_count():
				log.push_back(active.get_children())
		else:
			log = []
		for i:Node in active.get_children():
			i.reparent(pool)
		return
	if key:
		var node: Node = active.get_node_or_null(key)
		if not node:
			return
		if reversable and active.get_child_count() == 1:
			if get_child_count():
				log.push_back(active.get_children())
		node.reparent(pool)


func get_screen(key: String) -> Control:
	var screen: Control = active.get_node_or_null(key)
	if screen:
		return screen
	screen = pool.get_node_or_null(key)
	if screen:
		screen.reparent(active)
		return screen
	return screen
