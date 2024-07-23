extends Control

signal quest_changed(quest_index: int)

var quests: Array = [
	#"mushroom",
	#"pre-forest",
	"wolf1",
	"wolf2",
	"post-forest",
	"pre-bats",
	"post-bats",
]

var _current_quest_index: int = 0

var current_quest_index: int:
	get:
		return _current_quest_index
	set(value):
		var old_index = _current_quest_index
		_current_quest_index = clamp(value, 0, quests.size() - 1)
		if old_index != _current_quest_index:
			emit_signal("quest_changed", _current_quest_index)

func advance_quest() -> void:
	self.current_quest_index += 1  # Using self. to trigger the setter

func get_current_quest() -> String:
	return quests[current_quest_index]

func is_quest_active(quest_name: String) -> bool:
	return quest_name == get_current_quest()
