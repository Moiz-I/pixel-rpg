extends Node2D

#@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $NinePatchRect/MarginContainer/Label
@onready var textbox = $Textbox
@onready var audio_player = $AudioStreamPlayer
const base_text = "[E] to "
var active_areas = []
var can_interact = true
var textbox_was_visible = false  # New variable to track textbox visibility


func _ready():
	textbox.scale = Vector2.ZERO

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		textbox.global_position = active_areas[0].global_position
		textbox.global_position.y -= 50
		textbox.global_position.x -= textbox.size.x / 2
		
		if not textbox_was_visible:
			textbox.show()
			audio_player.play()	
#			textbox.pivot_offset = Vector2(textbox.size.x/2, textbox.size.y)
			var tween = get_tree().create_tween()
			tween.tween_property(
				textbox, "scale", Vector2(1,1), 0.1
			).set_trans(Tween.TRANS_BACK)
			textbox_was_visible = true
	else:
		if textbox_was_visible:
			textbox.hide()
			textbox.scale = Vector2.ZERO
			textbox_was_visible = false

func _sort_by_distance_to_player(area1, area2):
	var player = get_tree().get_first_node_in_group("player")
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			textbox.hide()
			textbox_was_visible = false
			await active_areas[0].interact.call()
			can_interact = true
