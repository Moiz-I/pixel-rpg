extends Node2D
#
#
#var COIN_SCENE = preload("res://Inventory/item.tscn")
#var jam = preload("res://Inventory/Items/jam.tres")
#@onready var player = $Player
#
#const MIN_X =  10.0
#const MAX_X = 150.0
#const MIN_Y = -80.0
#const MAX_Y =  80.0
#
#func _ready():
#	randomize()
#
#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		var coins = []
#
#		for i in range(5):
#			var idk = COIN_SCENE.instantiate()
#			idk.item = jam
#			coins.append(idk)
#			coins[i].position = player.position + Vector2(50, 10)
#			add_child(coins[i])
#
#		var tween = get_tree().create_tween()
##		add_child(tween)
#
#		for coin in coins:
#			var direction = 1 if randi() % 2 == 0 else -1
#			var goal = coin.position + Vector2(randf_range(MIN_X, MAX_X), randf_range(MIN_Y, MAX_Y)) * direction
# 
#			tween.tween_property(coin, "position:x", goal.x, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
#			tween.tween_property(coin, "position:y", goal.y - 50, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
#			tween.tween_property(coin, "position:y", goal.y, 0.4).set_delay(0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
#			tween.tween_property(coin, "position:y", goal.y - 10, 0.1).set_delay(0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
#			tween.tween_property(coin, "position:y", goal.y, 0.1).set_delay(0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
#
#
##		tween.start()
