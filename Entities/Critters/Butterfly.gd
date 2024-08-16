extends CharacterBody2D

@export var speed = 60
@export_range(0.0, 1.0) var friction = 200  # Friction factor
@export var acceleration = 300

@onready var wanderController = $WanderController
@onready var sprite = $Sprite2D

var types = ["blue", "purple"]

enum {
	IDLE,
	WANDER,
}

var state = IDLE
var inv_item: InvItem

func _ready():
	randomize()
	var butterflyType = pick_random_state(types)
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count(butterflyType)-1)
	sprite.play(butterflyType)
	state = pick_random_state([IDLE, WANDER])
	
	inv_item = InvItem.new()
	inv_item.name = butterflyType
	inv_item.texture = sprite.sprite_frames.get_frame_texture(butterflyType, 2)

func _physics_process(delta: float) -> void:
	#if softCollision.is_colliding():
		#velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()
	
	match state:
		IDLE:
#			velocity = velocity.move_toward(Vector2.ZERO, friction * speed * delta)
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if wanderController.get_time_left()==0:
				update_wander()
				
		WANDER:
			if wanderController.get_time_left()==0:
				update_wander()

			accelerate_towards_point(delta, wanderController.target_position)

			if global_position.distance_to(wanderController.target_position) <= (speed * delta):
				update_wander()


func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randi_range(0,1))

func accelerate_towards_point(delta, point):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction*speed, acceleration*delta)
	#sprite.flip_h = velocity.x < 0

func pick_random_state(state_list):
	return state_list.pick_random()
	



func _on_area_2d_area_entered(area: Area2D) -> void:
	area.emit_signal("tool_collected_item", inv_item)
	queue_free()
