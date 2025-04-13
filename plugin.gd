@tool
class_name FUIEditorPlugin
extends EditorPlugin


func _enter_tree() -> void:
	if not ProjectSettings.has_setting(FUIConsts.INITIAL_PATH_SETTING):
		ProjectSettings.set_setting(FUIConsts.INITIAL_PATH_SETTING, "")
	ProjectSettings.set_initial_value(FUIConsts.INITIAL_PATH_SETTING, "")
	ProjectSettings.set_as_basic(FUIConsts.INITIAL_PATH_SETTING, true)
	ProjectSettings.add_property_info({
			"name": FUIConsts.INITIAL_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tscn,*.scn"
	})
	if not ProjectSettings.has_setting(FUIConsts.INITIAL_KEY_SETTING):
		ProjectSettings.set_setting(FUIConsts.INITIAL_KEY_SETTING, "")
	ProjectSettings.set_initial_value(FUIConsts.INITIAL_KEY_SETTING, "")
	ProjectSettings.set_as_basic(FUIConsts.INITIAL_KEY_SETTING, true)
	ProjectSettings.add_property_info({
			"name": FUIConsts.INITIAL_KEY_SETTING,
			"type": TYPE_STRING,
	})
	add_autoload_singleton("FUIManager", "./nodes/ui_manager.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton("FUIManager")
