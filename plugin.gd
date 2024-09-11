@tool
class_name FUIEditorPlugin
extends EditorPlugin

const INITIAL_PATH_SETTING: String = "fast_ui/initial_path"
const INITIAL_KEY_SETTING: String = "fast_ui/initial_key"
const LASY_LOAD_SETTING: String = "fast_ui/lazy_load"

func _enter_tree() -> void:
	# if not ProjectSettings.has_setting(SCREENS_SETTING):
	# 	ProjectSettings.set_setting(SCREENS_SETTING, [])
	# ProjectSettings.set_initial_value(SCREENS_SETTING, [])
	# ProjectSettings.set_as_basic(SCREENS_SETTING, true)
	# ProjectSettings.add_property_info({
	# 		"name": SCREENS_SETTING,
	# 		"type": TYPE_ARRAY,
	# 		"hint": PROPERTY_HINT_TYPE_STRING,
	# 		"hint_string": "%d/%d:*.tscn,*.scn" % [TYPE_STRING, PROPERTY_HINT_FILE]
	# })
	if not ProjectSettings.has_setting(INITIAL_PATH_SETTING):
		ProjectSettings.set_setting(INITIAL_PATH_SETTING, "")
	ProjectSettings.set_initial_value(INITIAL_PATH_SETTING, "")
	ProjectSettings.set_as_basic(INITIAL_PATH_SETTING, true)
	ProjectSettings.add_property_info({
			"name": INITIAL_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tscn,*.scn"
	})
	if not ProjectSettings.has_setting(INITIAL_KEY_SETTING):
		ProjectSettings.set_setting(INITIAL_KEY_SETTING, "")
	ProjectSettings.set_initial_value(INITIAL_KEY_SETTING, "")
	ProjectSettings.set_as_basic(INITIAL_KEY_SETTING, true)
	ProjectSettings.add_property_info({
			"name": INITIAL_KEY_SETTING,
			"type": TYPE_STRING,
	})
	if not ProjectSettings.has_setting(LASY_LOAD_SETTING):
		ProjectSettings.set_setting(LASY_LOAD_SETTING, true)
	ProjectSettings.set_initial_value(LASY_LOAD_SETTING, true)
	ProjectSettings.set_as_basic(LASY_LOAD_SETTING, true)
	ProjectSettings.add_property_info({
			"name": LASY_LOAD_SETTING,
			"type": TYPE_BOOL,
	})
	add_autoload_singleton("FUIManager", "./nodes/ui_manager.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton("FUIManager")
