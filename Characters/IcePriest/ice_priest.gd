extends CharacterBody2D

@export var dialog: CharacterDialog
@onready var speech_sound = preload("res://Dialog/ghost_speech.wav")
		
func start_priest_dialog():
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(QuestManager.get_current_quest())
	DialogManager.start_dialog(global_position, lines, speech_sound,null, 0) 
	await DialogManager.dialog_finished
	if QuestManager.get_current_quest() != "post-bats":
		SceneManager.swap_scenes(SceneRegistry.levels["training_arena"],get_tree().root,get_parent(),"wipe_to_right")	
	print("dialog finished ", QuestManager.get_current_quest())
	#if QuestManager.current_quest_index==0:
		#QuestManager.advance_quest()

