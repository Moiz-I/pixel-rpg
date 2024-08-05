extends Node2D
@onready var player = $Player
@onready var player_camera = $Camera2D
@onready var frog_camera = $FrogGuy/Camera2D
@onready var coyote = $Coyote
@onready var coyote_post = $InvisibleSpawnPoints/CoyotePost
@onready var player_spawn = $InvisibleSpawnPoints/Player/Spawn
@onready var post_wolf = $InvisibleSpawnPoints/Player/PostWolf
@onready var post_bats = $InvisibleSpawnPoints/Player/PostBats
@onready var fail_tree_pos = $InvisibleSpawnPoints/TreeBatFail

@onready var topWolf = $wolfTop
@onready var wolfL2 = $wolfL2
@onready var wolfR2 = $wolfL3
@onready var ice_priest = $IcePriest

@onready var cutscene_effect = $CutsceneEffect
@onready var animation_player = $AnimationPlayer
@onready var health_ui = $CanvasLayer/HealthUI
@onready var snow_block_tree = $SnowBlockTrees
@onready var cutscene_trigger_snow = $CutsceneTriggerSnow
@onready var cutscene_trigger_wolf = $CutsceneTriggerWolf
var bat_fail_tree = preload("res://Entities/World/Objects/blue_tree_small.tscn")
@onready var color_rect = $CanvasLayer/ColorRect

func player_death():
	player.respawn()
	if QuestManager.get_current_quest()=="post-wolf":
		color_rect.visible = true
		await get_tree().create_timer(2).timeout
		color_rect.visible = false
		player.position = post_wolf.position
		cutscene_effect.end_cutscene()
		player_camera.offset.y = 0
		health_ui.position.y = 8
		print("df ", snow_block_tree)
		if snow_block_tree != null:
			snow_block_tree.queue_free()
	else:
		player.position = player_spawn.position

func _ready():
	player.debug_invincibility = false
	player.connect("player_died", player_death)
	player.position = player_spawn.position
	QuestManager.connect("quest_changed", Callable(self, "_on_quest_changed"))
	if QuestManager.get_current_quest()=="post-bats":
		player.position = post_bats.position
		player_camera.offset.y = -50
		cutscene_effect.start_cutscene()
		player.start_cutscene(0, Vector2.UP)
		if cutscene_trigger_snow != null:
			cutscene_trigger_snow.queue_free()
		await ice_priest.start_priest_dialog()
		cutscene_effect.end_cutscene()
		player_camera.offset.y = 0
	if QuestManager.get_current_quest()=="bats-fail":
		player.position = post_bats.position
		player_camera.offset.y = -50
		cutscene_effect.start_cutscene()
		player.start_cutscene(0, Vector2.UP)
		await get_tree().create_timer(1).timeout
		await ice_priest.start_priest_dialog()
		#var fail_tree = bat_fail_tree.instantiate()
		#get_tree().a
		#fail_tree.position = fail_tree_pos.position

func _on_quest_changed(quest_index: int):
	if quest_index == 1:  # "pre-forest" quest
		coyote.position = coyote_post.position
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_input()
		#if player_camera.is_current():
			#CameraTransition.transition_camera2D(player_camera,frog_camera, 2.0)
		#elif frog_camera.is_current():
			#CameraTransition.transition_camera2D(frog_camera,player_camera, 2.0)
#
#
#func CameraTransitionAnimation() -> void:
	#CameraTransition.transition_camera2D(player_camera,frog_camera, 1.0)
func get_input():
	if Input.is_action_just_pressed("open_settings"):
		Globals.open_settings_menu()
	#if Input.is_action_just_pressed("ui_accept"):
		##wolf.trigger_attack()
		#player.start_cutscene(150, Vector2.DOWN)
		#cutscene_effect.start_cutscene()
		#await get_tree().create_timer(3).timeout
		#animation_player.play("wolf_attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="wolf_attack":
		player.default_health()
		await topWolf.start_wolf_dialog() #wolf1
		wolfL2.trigger_attack()
		await get_tree().create_timer(1).timeout
		await topWolf.start_wolf_dialog() #wolf2
		await wolfR2.trigger_attack()
		await get_tree().create_timer(1).timeout
		await topWolf.start_wolf_dialog() #wolf3
		wolfL2.trigger_attack()

	if anim_name=="snow":
		await ice_priest.start_priest_dialog()
		print("change scene")

func _on_cutscene_trigger_snow_body_entered(body: Node2D) -> void:
	player.start_cutscene(80, Vector2.UP)
	cutscene_effect.start_cutscene()
	await get_tree().create_timer(1.4).timeout
	animation_player.play("snow")
	#start dialog
	


func _on_cutscene_trigger_wolf_body_entered(body: Node2D) -> void:
		MusicPlayer.transition("storm_night")
		player.start_cutscene(150, Vector2.DOWN)
		cutscene_effect.start_cutscene()
		await get_tree().create_timer(3).timeout
		animation_player.play("wolf_attack")


func _on_cutscene_trigger_forest_body_entered(body: Node2D) -> void:
	MusicPlayer.transition("national_park")


func _on_cutscene_trigger_snow_biome_body_entered(body: Node2D) -> void:
	MusicPlayer.transition("ice_village")
