extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound = preload("res://Assets/Music and Sounds/Dialog/ghost_speech.wav")
@onready var coyote_camera = $Camera2D

@export var dialog: CharacterDialog

var current_condition: String 


func _ready():
	#match QuestManager.current_quest_index:
		#0:
			#current_condition = "mushroom"
		#1:
			#current_condition = "pre_forest"
		#_:
			#current_condition = "post-forest"
	QuestManager.connect("quest_changed", Callable(self, "_on_quest_changed"))
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_quest_changed(quest_index: int):
	if quest_index == 1:  # "pre-forest" quest
		print("new position")

	
func _on_interact():
	var current_quest = QuestManager.get_current_quest()
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(current_quest)
	print("sdf", lines, current_condition, QuestManager.current_quest_index)
	DialogManager.start_dialog(global_position, lines, speech_sound, coyote_camera) 
	#spite flip
	await DialogManager.dialog_finished
	#if QuestManager.current_quest_index==0:
		#print("switching wscenes ", self)
		#SceneManager.swap_scenes(SceneRegistry.levels["training_arena"],get_tree().root,get_parent(),"wipe_to_right")	
