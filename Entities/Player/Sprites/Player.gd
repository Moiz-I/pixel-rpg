extends CharacterBody2D

@export var inv: Inv
@export var tool_inv: Inv

@export var SPEED = 140
@export_range(0.0, 1.0) var ACCELERATION = 0.1
@export_range(0.0, 1.0) var FRICTION = 0.3
@export var ROLL_SPEED = SPEED * 1.5
@export var debug_invincibility: bool = false

var cutscene_target_distance: int # 150
var cutscene_velocity: Vector2 
var cutscene_travelled_distance = 0

var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var footstep_timer = $FootstepTimer
@onready var audio_player = $FootstepAudio
@onready var pickup_audio = $ItemPickupAudio
@onready var tool_hitbox = $HitboxPivot/ToolHitbox
const PlayerHurtSound = preload("res://Entities/Player/player_hurt_sound.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK,
	BUGNET,
	CUTSCENE
}
@export var state = MOVE

signal player_died

func on_player_death():
	player_died.emit()
	#queue_free()
	
func default_health():
	stats.max_health = 3
	stats.reset_health()
	
func respawn():
	stats.reset_health()

func _ready():
	stats.connect("no_health", on_player_death)
	tool_hitbox.connect("tool_collected_item", Callable(collect_item))
	

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
		animation_tree.set("parameters/BugNet/blend_position", input_direction)
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
	
	if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("primary"):
		if tool_inv.items[0].name == "sword":
			state = ATTACK
		elif tool_inv.items[0].name == "bug_net":
			state = BUGNET

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	#velocity = velocity.move_toward(Vector2.ZERO, friction/2 * delta)
	#move_and_slide()
	
func bug_net_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("BugNet")
	
func roll_state(delta):
	var v = roll_vector * ROLL_SPEED
	velocity = velocity.move_toward(v, 0.2 * SPEED)
	animation_state.travel("Roll")
	move_and_slide()
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["AttackRight", "AttackLeft", "AttackUp", "AttackDown", "RollDown", "RollLeft", "RollRight", "RollUp", "bug_net_right"]:
		state = MOVE
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if !hurtbox.invincible and !debug_invincibility:
		stats.health-=1
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instantiate()
		#get_tree().current_scene.add_child(playerHurtSound)
		get_parent().add_child(playerHurtSound)

func collect_item(item: InvItem):
	print("collected ", item)
	if item.name=="heart_red":
		stats.health +=1
	if item.name=="heart_gold":
		stats.max_health +=1
		stats.reset_health()
	else:
		inv.insert_item(item)
	pickup_audio.play()
	
func start_cutscene(target_distance: int, direction: Vector2):
	cutscene_target_distance = target_distance
	cutscene_velocity = direction * SPEED *0.6
	state = CUTSCENE
	cutscene_travelled_distance = 0
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_state.travel("Run")
	if target_distance==0:
		animation_state.travel("Idle")

func cutscene_state(delta):
	velocity = cutscene_velocity
	move_and_slide()
	cutscene_travelled_distance += cutscene_velocity.length() * delta
	if cutscene_travelled_distance >= cutscene_target_distance:
		state = MOVE


func _physics_process(delta):
	if DialogManager.is_dialog_active:
		return
	match state:
		MOVE:
			get_input()
			move_and_slide()
		ROLL: 
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		BUGNET:
			bug_net_state(delta)
		CUTSCENE:
			cutscene_state(delta)
			

		
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

