extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Dialog/ghost_speech.wav")

@export var dialog: CharacterDialog

var current_condition: String 


func _ready():
	match QuestManager.current_quest_index:
		0:
			current_condition = "pre-bat"
		1:
			current_condition = "post-bat"
		
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(current_condition)
	print("sdf", lines, current_condition, QuestManager.current_quest_index)
	DialogManager.start_dialog(global_position, lines, speech_sound) 
	#spite flip
	await DialogManager.dialog_finished
	if QuestManager.current_quest_index==0:
		print("switching wscenes ", self)
		SceneManager.swap_scenes(SceneRegistry.levels["training_arena"],get_tree().root,get_parent(),"wipe_to_right")	
