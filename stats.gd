extends Node

@export var max_health = 1:
	set(value):
		max_health = max(value, 1)
		emit_signal("max_health_changed", max_health)
@onready var health = max_health:
	get:
		return health
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", health)
		if health<=0:
			emit_signal("no_health")

func _ready():
	self.health = max_health

signal no_health
signal health_changed
signal max_health_changed
