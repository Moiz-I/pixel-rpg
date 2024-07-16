extends Control

@export var current_quest_index = 0

var quests = [
	"start",
	"pre-bats",
	"post-bats",
	"craft-sword"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func advance_quest():
	current_quest_index+=1

func set_quest(index: int):
	current_quest_index = index
