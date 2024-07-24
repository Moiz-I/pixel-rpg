extends CharacterBody2D

@export var dialog: CharacterDialog
@onready var speech_sound = preload("res://Dialog/ghost_speech.wav")

@export var is_flipped: bool = false
@export var top: bool = false

@export var attack_distance = 50.0
@export var attack_speed = 180.0
@export var return_speed = 200.0

@export var run_distance = 74.0
@export var run_speed = 70.0

var initial_position = Vector2.ZERO
var is_attacking = false
var is_running = false
var attack_target = Vector2.ZERO
var run_target = Vector2.ZERO
var is_returning = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var hitboxCollision = $Hitbox/CollisionShape2D

func _ready():
	randomize() #changes seed
	initial_position = global_position
	animated_sprite.frame = randi() % animated_sprite.sprite_frames.get_frame_count("idle")
	animated_sprite.play("idle")
	animated_sprite.flip_h = is_flipped
	if top:
		hitboxCollision.disabled = true

func _physics_process(delta):
	if is_attacking:
		perform_attack(delta)
	elif is_running:
		perform_run(delta)
	else:
		# Check for attack or run condition here
		pass
		
func start_run():
	if not is_running and not is_attacking:
		is_running = true
		animated_sprite.play("run") 
		if top:
			run_target = global_position + Vector2(0, 50)
		else:
			run_target = global_position + Vector2(run_distance * (-1 if is_flipped else 1), 0)
		initial_position = run_target	

func perform_run(delta):
	var direction = (run_target - global_position).normalized()
	
	if global_position.distance_to(run_target) > 5:
		velocity = direction * run_speed
	else:
		end_run()
	
	move_and_slide()

func end_run():
	is_running = false
	velocity = Vector2.ZERO
	animated_sprite.play("idle")

func start_attack():
	if not is_attacking and not is_running:
		animated_sprite.play("attack")
		is_attacking = true
		is_returning = false
		attack_target = global_position + Vector2(attack_distance * (-1 if is_flipped else 1), 0)

func perform_attack(delta):
	var direction = (attack_target - global_position).normalized()
	
	if not is_returning:
		if global_position.distance_to(attack_target) > 5:
			velocity = direction * attack_speed
		else:
			is_returning = true
	else:
		if global_position.distance_to(initial_position) > 5:
			velocity = (initial_position - global_position).normalized() * return_speed
		else:
			end_attack()
	
	move_and_slide()

func end_attack():
	is_attacking = false
	is_returning = false
	velocity = Vector2.ZERO
	animated_sprite.play("idle")

# Call this function when you want the wolf to attack
func trigger_attack():
	if not is_attacking and not is_running:
		start_attack()

# Call this function when you want the wolf to run
func trigger_run():
	if not is_attacking and not is_running:
		start_run()
		
func start_wolf_dialog():
	dialog.load_dialog()
	var lines = dialog.get_dialog_by_condition(QuestManager.get_current_quest())
	DialogManager.start_dialog(global_position, lines, speech_sound,null, 27) 
	await DialogManager.dialog_finished
	QuestManager.advance_quest()
	print("dialog finished ", QuestManager.get_current_quest())
	#if QuestManager.current_quest_index==0:
		#QuestManager.advance_quest()

# Connect this to the AnimatedSprite2D's animation_finished signal
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack" and is_attacking and not is_returning:
		is_returning = true
