extends Node2D

var bats_killed: int = 0
const SPAWN_RANGE: float = 100

var bat_object = preload("res://Enemies/bat.tscn")

@onready var counter_label = $CanvasLayer/Control/Label
@onready var player = $Player
@onready var enemies = $enemies

func player_death():
	for n in enemies.get_children():
		enemies.remove_child(n)
		n.queue_free()
	SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")
	player.respawn()	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counter_label.text = "0"
	
	player.connect("player_died", player_death)
	
	spawn_bat()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bats_killed==2:
		QuestManager.set_quest(1)
		SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")	


func spawn_bat():
	var bat = bat_object.instantiate()
	bat.connect("on_bat_killed", bat_killed)
	enemies.add_child(bat)
	
	var random_offset = Vector2(
		randf_range(-SPAWN_RANGE, SPAWN_RANGE),
		randf_range(-SPAWN_RANGE, SPAWN_RANGE)
	)
	
	bat.position = player.position + random_offset

func bat_killed():
	bats_killed +=1
	counter_label.text = str(bats_killed)
	

func _on_timer_timeout() -> void:
	spawn_bat()
