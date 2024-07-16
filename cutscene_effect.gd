extends CanvasLayer

@onready var animation_player = $Control/AnimationPlayer
var cutscene_played: bool = false
var was_dialog_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DialogManager.is_dialog_active:
		if not cutscene_played:
			animation_player.play("cutscene")
			cutscene_played = true
		was_dialog_active = true
	else:
		if was_dialog_active:
			animation_player.play("cutscene_finished")
			was_dialog_active = false
			cutscene_played = false # Reset the flag if you want the cutscene to play again next time the dialog starts
