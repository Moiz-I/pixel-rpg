extends Node2D
@onready var player = $Player
@onready var player_camera = $Camera2D
@onready var frog_camera = $FrogGuy/Camera2D
@onready var coyote = $Coyote
@onready var coyote_post = $InvisibleSpawnPoints/CoyotePost

@onready var topWolf = $wolfTop
@onready var wolfL1 = $wolfL1
@onready var wolfL4 = $wolfL4

@onready var cutscene_effect = $CutsceneEffect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	QuestManager.connect("quest_changed", Callable(self, "_on_quest_changed"))

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
	if Input.is_action_just_pressed("ui_accept"):
		#wolf.trigger_attack()
		player.start_cutscene()
		cutscene_effect.start_cutscene()
		await get_tree().create_timer(3).timeout
		animation_player.play("wolf_attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await topWolf.start_wolf_dialog()
	await wolfL1.trigger_attack()
	await wolfL4.trigger_attack()
