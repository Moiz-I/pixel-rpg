extends CharacterBody2D

@export var loot_table: LootTable
var test_table: LootTable = LootTable.new()
var loot_item = preload("res://Entities/Inventory/item.tscn")

@export var speed = 60
@export_range(0.0, 1.0) var friction = 200  # Friction factor
@export var acceleration = 300

@export var isIce: bool = false
@export var isStationary: bool = false

@onready var sprite_normal = $AnimatedSprite2D
@onready var sprite_ice = $AnimatedSprite2DIce

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
const deathEffect = preload("res://Entities/Effects/enemy_death_effect.tscn")
const jamItem = preload("res://Entities/Inventory/Items/jam.tres")
const watermelonItem = preload("res://Entities/Inventory/Items/watermelon.tres")
const heart_red = preload("res://Entities/Inventory/Items/heart_red.tres")
const heart_gold = preload("res://Entities/Inventory/Items/heart_gold.tres")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var sprite: AnimatedSprite2D

func _ready():
	randomize() #changes seed
	if isStationary:
		state = IDLE
	else:
		state = pick_random_state([IDLE, WANDER])
		
	if isIce:
		sprite = sprite_ice
		sprite_normal.queue_free()
	else:
		sprite = sprite_normal
		sprite_ice.queue_free()
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count("Fly")-1)
	sprite.flip_h = randi() % 2 == 0
	
#	print("l ", loot_table.table)
	#test_table.add_item(jamItem, 0.2)
	#test_table.add_item(watermelonItem, 0.8)
	test_table.add_item(heart_red, 0.6)
	test_table.add_item(heart_gold, 0.4)

func _physics_process(delta: float) -> void:
#	apply_friction(delta)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()
	
	match state:
		IDLE:
#			velocity = velocity.move_toward(Vector2.ZERO, friction * speed * delta)
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left()==0 and !isStationary:
				update_wander()
		WANDER:
			seek_player( )
			if wanderController.get_time_left()==0:
				update_wander()
			
			accelerate_towards_point(delta, wanderController.target_position)
			
			if global_position.distance_to(wanderController.target_position) <= (speed * delta):
				update_wander()
			
		CHASE:
			if DialogManager.is_dialog_active or isStationary:
				return 
				
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(delta, player.global_position)
			else:
				state = IDLE
				
				
func accelerate_towards_point(delta, point):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction*speed, acceleration*delta)
	sprite.flip_h = velocity.x < 0
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randi_range(1,2))
		
func pick_random_state(state_list):
	return state_list.pick_random()
	

func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * speed * delta)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var direction = (position - area.owner.position).normalized()
	velocity = direction * 100
	stats.health -=area.damage
	hurtbox.create_hit_effect()
	
func create_death_effect():
	randomize()
	var effect = deathEffect.instantiate()
	get_parent().add_child(effect)
	effect.position = position
	if randi() % 2 == 0 and (QuestManager.get_current_quest()=="post-wolf" or QuestManager.get_current_quest()=="bats-fail"):
		drop_loot()
	
func drop_loot():
	loot_item = loot_item.instantiate()
	var loot_drop: InvItem = test_table.get_random_item()
	loot_item.item = loot_drop
	get_parent().add_child(loot_item)
	loot_item.position = position
	# print("v dl", velocity)
	loot_item.loot_item_dropped(velocity)
	


func _on_stats_no_health() -> void:
	on_bat_killed.emit()
	create_death_effect()
	queue_free()

signal on_bat_killed
