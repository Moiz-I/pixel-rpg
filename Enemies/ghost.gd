extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var playerDetectionZone = $PlayerDetectionZone

@export var speed = 60
@export_range(0.0, 1.0) var friction = 200  # Friction factor
@export var acceleration = 300


func _ready():
	randomize()
	sprite.frame = randf_range(0, sprite.sprite_frames.get_frame_count("Fly")-1)
	sprite.flip_h = randi() % 2 == 0
	

func _process(delta):
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
