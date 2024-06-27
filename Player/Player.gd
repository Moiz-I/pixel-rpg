extends CharacterBody2D

@export var inv: Inv

@export var SPEED = 140
@export_range(0.0, 1.0) var ACCELERATION = 0.1
@export_range(0.0, 1.0) var FRICTION = 0.3
@export var ROLL_SPEED = SPEED * 1.5
@export var debug_invincibility: bool = false

var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var footstep_timer = $FootstepTimer
@onready var audio_player = $FootstepAudio
const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK 
}
@export var state = MOVE

func _ready():
	stats.connect("no_health", queue_free)
	print(stats.health)

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction.length() > 0:#ismoving
		#audio
		if footstep_timer.time_left <=0:
			audio_player.play()
			footstep_timer.start(0.5)
		
		roll_vector = input_direction
		animation_tree.set("parameters/Idle/blend_position", input_direction)
		animation_tree.set("parameters/Run/blend_position", input_direction)
		animation_tree.set("parameters/Attack/blend_position", input_direction)
		animation_tree.set("parameters/Roll/blend_position", input_direction)
		animation_state.travel("Run")
		input_direction = input_direction.normalized()
		var target_velocity = input_direction * SPEED
		velocity = velocity.move_toward(target_velocity, ACCELERATION * SPEED)
	else:#isstill
		audio_player.stop()
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * SPEED)
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	#velocity = velocity.move_toward(Vector2.ZERO, friction/2 * delta)
	#move_and_slide()
	
func roll_state(delta):
	var v = roll_vector * ROLL_SPEED
	velocity = velocity.move_toward(v, 0.2 * SPEED)
	animation_state.travel("Roll")
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["AttackRight", "AttackLeft", "AttackUp", "AttackDown", "RollDown", "RollLeft", "RollRight", "RollUp"]:
		state = MOVE
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if !hurtbox.invincible and !debug_invincibility:
		stats.health-=1
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instantiate()
		get_tree().current_scene.add_child(playerHurtSound)

func collect_item(item: InvItem):
	inv.insert_item(item)

func _physics_process(delta):
	match state:
		MOVE:
			get_input()
			move_and_slide()
		ROLL: 
			roll_state(delta)
		ATTACK:
			attack_state(delta)
			

		
#const SPEED = 300.0ve
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()


