extends Node

@onready var text_box_scene = preload("res://Dialog/textbox.tscn")
#@onready var player = get_tree().get_first_node_in_group("player")

var dialog_lines: Array = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var character_position: Vector2
var sfx: AudioStream

var is_dialog_active = false
var can_advance_line = false

signal dialog_finished()

func start_dialog(position: Vector2, lines: Array, speech_sfx: AudioStream):
	if is_dialog_active:
		return

	character_position = position
	dialog_lines = lines
	sfx = speech_sfx
	current_line_index = 0
	is_dialog_active = true
	
	_update_text_box_position()
	_show_text_box()

func _update_text_box_position():
	var player = get_tree().get_first_node_in_group("player")
	var is_player = dialog_lines[current_line_index]["speaker"] == "Player"
	if is_player:
		text_box_position = player.global_position
		text_box_position.y -= 13
	else:
		text_box_position = character_position
		text_box_position.y -= 0

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	#get_tree().root.add_child(text_box)
	get_parent().add_child(text_box)
	
	_update_text_box_position()
	text_box.global_position = text_box_position
	
	var is_player = dialog_lines[current_line_index]["speaker"] == "Player"
	text_box.display_text(dialog_lines[current_line_index].text, sfx, is_player)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialog") &&
		is_dialog_active &&
		can_advance_line
	):
		advance_dialog()

func advance_dialog():
	text_box.queue_free()
	
	current_line_index += 1
	
	if current_line_index >= dialog_lines.size():
		end_dialog()
		return
	
	_show_text_box()
	print("current line: ", current_line_index, "speaker: ", dialog_lines[current_line_index]["speaker"])

func end_dialog():
	is_dialog_active = false
	current_line_index = 0
	dialog_finished.emit()
