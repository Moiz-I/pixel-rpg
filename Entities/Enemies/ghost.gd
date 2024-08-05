extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var speech_sound = preload("res://Assets/Music and Sounds/Dialog/ghost_speech.wav")

@export var dialog: CharacterDialog

# const lines: Array[String] = [
# 	"hello there",
# 	"nice day isnt it?",
# 	"building sandcastles and what not and building sandcastles and what not",
# 	"...",
# 	"well...",
# ]

const newLines: Array[Dictionary] = [
 		{
 		  "speaker": "Ghost",
 		  "text": "You've returned! And you've completed the task!"
 		},
 		{
 		  "speaker": "Player",
 		  "text": "Yes, it wasn't easy, but I managed to do it."
 		},
 		{
 		  "speaker": "Ghost",
 		  "text": "I'm eternally grateful. Now I can finally rest in peace."
 		}
]
var current_condition = "quest_completed"

@export var speed = 60
@export_range(0.0, 1.0) var friction = 200  # Friction factor
@export var acceleration = 300


func _ready():
	randomize()
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count("Fly")-1)
	sprite.flip_h = randi() % 2 == 0
	
	# print("current lines: ", dialog.get_dialog_by_condition(current_condition))
	
	if QuestManager.current_quest_index==0:
		print("starttt")
	
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(current_condition)
	DialogManager.start_dialog(global_position, lines, speech_sound) #add speech_sound
	#spite flip
	await DialogManager.dialog_finished

func _process(delta):
	pass
#	var player = playerDetectionZone.player
#	if player != null:
#		accelerate_towards_point(delta, player.global_position)
#	move_and_slide()

func _on_player_detection_zone_body_entered(body: Node2D) -> void:
	print("ghost", body,)
#	var direction = (position - body.position).normalized()
#	velocity = -direction * 2

func accelerate_towards_point(delta, point):
	print("point ", point)
	var direction = global_position.direction_to(point*2) 
	velocity = velocity.move_toward(direction*speed, acceleration*delta)
	sprite.flip_h = velocity.x < 0
