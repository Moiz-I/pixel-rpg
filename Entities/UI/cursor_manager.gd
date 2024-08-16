extends CanvasLayer

var empty_cursor = preload("res://Entities/UI/Assets/Cursors/EmptyCursor.png")
@onready var custom_cursor = $Sprite2D
@onready var select_cursor = $Select

var current_cursor: String = "default"

func _ready() -> void:
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)

func set_cursor(type: String):
	if type=="select":
		current_cursor = "select"
		select_cursor.visible = true
		custom_cursor.visible = false
		select_cursor.modulate = Color(1,1,1,1)
	if type=="select_disabled":
		current_cursor = "select"
		select_cursor.visible = true
		custom_cursor.visible = false
		select_cursor.modulate = Color(1,0,0)
	if type == "default":
		current_cursor = "default"
		select_cursor.visible = false
		custom_cursor.visible = true

func _process(delta: float) -> void:
	if current_cursor == "select":
		select_cursor.global_position = select_cursor.get_global_mouse_position()
	else:
		custom_cursor.global_position = custom_cursor.get_global_mouse_position()
