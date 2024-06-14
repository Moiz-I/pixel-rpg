extends CharacterBody2D

@export var speed = 60
@export_range(0.0, 1.0) var friction = 3  # Friction factor
@export var acceleration = 300

@onready var stats = $Stats
@onready var sprite = $AnimatedSprite2D
@onready var playerDetectionZone = $PlayerDetectionZone
const deathEffect = preload("res://Effects/enemy_death_effect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

func _physics_process(delta: float) -> void:
	apply_friction(delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * speed * delta)
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction*speed, acceleration)
				sprite.flip_h = velocity.x < 0
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * speed * delta)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var direction = (position - area.owner.position).normalized()
	velocity = direction * 100
	stats.health -=area.damage
	
func create_death_effect():
	var effect = deathEffect.instantiate()
	get_parent().add_child(effect)
	effect.position = position


func _on_stats_no_health() -> void:
	create_death_effect()
	queue_free()
