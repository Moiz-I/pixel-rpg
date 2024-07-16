extends Camera2D

var original_position: Vector2
var moved_position: Vector2
var cutscene_played: bool = false
var was_dialog_active: bool = false
var move_distance: Vector2 = Vector2(100, 0)  # Change this to the desired distance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position
	moved_position = original_position + move_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if DialogManager.is_dialog_active:
		if not cutscene_played:
			global_position.x += 80
			global_position.y -= 50
			self.zoom = Vector2(0.9, 0.9)
			cutscene_played = true
		was_dialog_active = true
	else:
		if was_dialog_active:
			global_position = original_position
			was_dialog_active = false
			cutscene_played = false  # Reset the flag if you want the cutscene to play again next time the dialog starts
