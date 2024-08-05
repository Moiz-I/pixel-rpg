extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Assets/Music and Sounds/Dialog/ghost_speech.wav")

@export var dialog: CharacterDialog

var current_condition = "first_meet"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(current_condition)
	print("lines ", lines)
	DialogManager.start_dialog(global_position, lines, speech_sound)
	await DialogManager.dialog_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
