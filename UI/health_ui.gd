extends Control

@onready var heartUIEmpty = $HeartUIEmpty
@onready var heartUIFull = $HeartUIFull


var hearts = 4:
	set = set_hearts
var max_hearts = 4:
	set = set_max_hearts
		
func set_max_hearts(value):
	max_hearts = value
	if heartUIEmpty:
		heartUIEmpty.size.x = max_hearts * 15
	
func set_hearts(value):
	hearts = value
	if heartUIFull:
		heartUIFull.size.x = hearts * 15
		
func _ready():
	self.max_hearts = PlayerStats.max_health #use self to make sure call setter
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", set_hearts)
	PlayerStats.connect("max_health_changed", set_max_hearts)
