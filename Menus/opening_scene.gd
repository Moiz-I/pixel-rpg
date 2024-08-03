extends Node2D

@onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneManager.swap_scenes(SceneRegistry.levels["start_scene"],get_tree().root,self,"fade_to_black")	
	
