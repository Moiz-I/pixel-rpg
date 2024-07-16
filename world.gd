extends Node2D
#@onready var quest_label = $CanvasLayer/Control
#@onready var quest_audio = $NewQuest
@onready var bg_audio = $BGAudio
@onready var coyote = $Coyote
@onready var coyote_pre =  $InvisibleSpawnPoints/CoyotePre
@onready var coyote_post =  $InvisibleSpawnPoints/CoyotePost
@onready var player_spawn = $InvisibleSpawnPoints/Player/Spawn
@onready var player = $Player

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
func player_death():
	player.respawn()
	player.position = player_spawn.position

func _ready():
	player.connect("player_died", player_death)
	
	match QuestManager.current_quest_index:
		0:
			coyote.position = coyote_pre.position
		1:
			coyote.position = coyote_post.position
			player.position = $InvisibleSpawnPoints/Player/PostBat.positio
	
##	randomize()
#	quest_label.scale = Vector2.ZERO
##
func _process(delta):
	if Input.is_action_just_pressed("open_settings"):
		Globals.open_settings_menu()
##		quest_label.show()
#		quest_audio.play()
#		var tween = get_tree().create_tween()
#		quest_label.pivot_offset = Vector2((quest_label.size.x / 2) + 30, quest_label.size.y - 20)
#		tween.tween_property(
#			quest_label, "scale", Vector2(1,1), 0.2
#		).set_trans(Tween.TRANS_BACK)
		
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




func _on_bg_audio_finished() -> void:
	bg_audio.play()


#func _on_settings_button_button_up() -> void:
	#print("clicked")
	#Globals.open_settings_menu()
