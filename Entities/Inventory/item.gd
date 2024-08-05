#extends CharacterBody2D
#
#@export var item: InvItem
#
#@onready var sprite = $Sprite2D
#@onready var timer = $Timer
#
#var uncollectable: bool = false:
#	set(value):
#		uncollectable = value
#		if uncollectable == true:
#			emit_signal("uncollectable_started")
#		else:
#			emit_signal("uncollectable_ended")
#
#
#signal uncollectable_started
#signal uncollectable_ended
#
#func start_uncollectable(duration):
#	self.uncollectable = true
#	timer.start(duration)
#
#
#func _on_timer_timeout() -> void:
#	self.uncollectable = false
#
##func _on_uncollectable_started() -> void:
##	set_deferred("monitoring", false)
##
##func _on_uncollectable_ended() -> void:
###	monitoring = true
##	pass
#
#func _process(delta: float) -> void:
#	move_and_slide()
#
#func _ready() -> void:
#	sprite.texture = item.texture
#
#func loot_item_dropped(new_velocity: Vector2):
#	start_uncollectable(0.5)
#	velocity = new_velocity
#	print("dropped", velocity, new_velocity)
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
#	print("entered", body)
#	if !uncollectable:
#		body.collect_item(item)
#		queue_free()
		
extends CharacterBody2D

@export var item: InvItem
@export var bounce_height: float = 10.0
@export var bounce_duration: float = 0.5
@export var gravity: float = 980.0

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var collision_shape = $Area2D/CollisionShape2D

var uncollectable: bool = false:
	set(value):
		uncollectable = value
		if uncollectable == true:
			emit_signal("uncollectable_started")
		else:
			emit_signal("uncollectable_ended")

signal uncollectable_started
signal uncollectable_ended

var initial_position: Vector2
var time_elapsed: float = 0.0
var is_bouncing: bool = false

func start_uncollectable(duration):
	self.uncollectable = true
	timer.start(duration)

func _on_timer_timeout() -> void:
	self.uncollectable = false

func _ready() -> void:
	sprite.texture = item.texture

func loot_item_dropped(drop_direction: Vector2):
	collision_shape.disabled = true
	start_uncollectable(0.5)
	initial_position = global_position
	velocity = drop_direction.normalized() * 10  # Adjust the speed as needed
	is_bouncing = true
	time_elapsed = 0.0

func _physics_process(delta: float) -> void:
	if is_bouncing:
		time_elapsed += delta

		# Define the necessary variables
		var max_horizontal_distance = 10  # Adjust this to set how far horizontally the object should travel

		# Calculate the parabolic horizontal movement
		var t = time_elapsed / bounce_duration
		var horizontal_movement = max_horizontal_distance * (4 * t * (1 - t))

		# Calculate vertical movement (parabolic path)
		var vertical_movement = 4 * bounce_height * t * (t - 1)
		
		# Apply gravity (if you want gravity to affect the bounce)
		# velocity.y += gravity * delta

		# Move the item
		global_position = initial_position + Vector2(horizontal_movement, vertical_movement)

		# Check if bounce is complete
		if time_elapsed >= bounce_duration:
			is_bouncing = false
			collision_shape.disabled = false
			velocity = Vector2.ZERO
			global_position.x = initial_position.x + max_horizontal_distance

	else:
		# Regular movement when not bouncing
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !uncollectable and !is_bouncing:
		body.collect_item(item)
		queue_free()
