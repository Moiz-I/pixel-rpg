extends Node2D

var bats_killed: int = 0
const SPAWN_RANGE: float = 100

var bat_object = preload("res://Entities/Enemies/bat.tscn")

@onready var counter_label = $CanvasLayer/Control/Label
@onready var player = $Player
@onready var enemies = $enemies
@onready var spawn = $Spawn

func player_death():
	for n in enemies.get_children():
		enemies.remove_child(n)
		n.queue_free()
	QuestManager.set_quest("bats-fail")
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")
	player.respawn()	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_music("fantasy_medieval")
	player.position = spawn.position
	counter_label.text = "bats killed: 0/10"
	
	player.connect("player_died", player_death)
	
	spawn_bat()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bats_killed>=10:
		player.debug_invincibility = true
		player.respawn()
		QuestManager.set_quest("post-bats")
		MusicPlayer.transition("route3")
		SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")	


func spawn_bat():
	var bat = bat_object.instantiate()
	bat.isIce = true
	bat.connect("on_bat_killed", bat_killed)
	enemies.add_child(bat)
	
	# Define the x and y range for spawning
	var min_x_range = 200
	var max_x_range = 580
	var min_y_range = 15
	var max_y_range = 200

	# Calculate a random offset within the specified range
	var random_pos = Vector2(
		randf_range(min_x_range, max_x_range),
		randf_range(min_y_range, max_y_range)
	)
	
	bat.position = random_pos

func bat_killed():
	bats_killed +=1
	counter_label.text = "bats killed: " + str(bats_killed) + "/10"
	

func _on_timer_timeout() -> void:
	spawn_bat()
