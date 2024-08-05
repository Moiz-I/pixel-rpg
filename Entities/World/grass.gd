extends Node2D

#var player_in_area = false
const grassEffect = preload("res://Entities/Effects/grass_effect.tscn")
#ANOTHER SOLUTION: to put the whole grasseffect scene nodes as children of grass scene instead of making new one.

func create_grass_effect():
	var effect = grassEffect.instantiate()
	get_parent().add_child(effect)
	effect.position = position
#	grassEffect.play_animation()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("attack") and player_in_area:
#		#var world = get_tree().current_scene
#		#world.add_child(grassEffect)
#		#grassEffect.global_position = global_position
#		get_parent().add_child(grassEffect)
#		grassEffect.position = position
#		grassEffect.play_animation()
#		queue_free()


# 
#func _on_area_2d_body_entered(body: Node2D) -> void:
#	pass
#	if body.name == "Player":
#		player_in_area = true
#

#func _on_hurtbox_area_entered(area: Area2D) -> void:
#	player_in_area = true
##	print("hurtbox area entereed")
##	create_grass_effect()
##	queue_free()
