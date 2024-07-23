extends Resource
class_name CharacterDialog

@export_file("*.json") var dialog_file: String

var _dialog_data: Dictionary = {}

func load_dialog() -> void:
	if dialog_file.is_empty():
		push_error("No dialog file specified")
		return

	var file = FileAccess.open(dialog_file, FileAccess.READ)
	if file == null:
		push_error("Failed to open dialog file: " + dialog_file)
		return

	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()

	if error == OK:
		_dialog_data = json.get_data()
	else:
		push_error("JSON Parse Error: " + json.get_error_message())

func get_character_name() -> String:
	return _dialog_data.get("character_name", "")

func get_dialog_by_condition(condition: String) -> Array:
	for dialog in _dialog_data.get("dialogs", []):
		if dialog.get("condition") == condition:
			return dialog.get("lines")
	return []

func _init():
	load_dialog()
