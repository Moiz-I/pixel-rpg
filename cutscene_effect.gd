extends CanvasLayer

@onready var animation_player = $Control/AnimationPlayer
@onready var player_camera = $"../Camera2D"
var cutscene_played: bool = false
var was_dialog_active: bool = false

var custom_cutscene:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !custom_cutscene:
		if DialogManager.is_dialog_active:
			if not cutscene_played:
				CameraTransition.switch_camera(player_camera,DialogManager.get_to_camera())
				animation_player.play("cutscene")
				cutscene_played = true
			was_dialog_active = true
		else:
			if was_dialog_active:
				CameraTransition.switch_camera(DialogManager.get_to_camera(),player_camera)
				animation_player.play("cutscene_finished")
				was_dialog_active = false
				cutscene_played = false # Reset the flag if you want the cutscene to play again next time the dialog starts

func start_cutscene():
	custom_cutscene = true
	animation_player.play("cutscene")

func end_cutscene():
	animation_player.play("cutscene_finished")
