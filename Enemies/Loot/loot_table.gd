extends Resource

class_name LootTable

#@export var loot_table: Array[LootItem] = []
@export var table: Array[Dictionary]

func add_item(item: InvItem, probability: float):
	table.append({"item": item, "probability": probability})


func get_random_item() -> InvItem:
	var total_probability = 0.0
	for entry in table:
		total_probability += entry["probability"]
	
	var random_value = randf() * total_probability
	var cumulative_probability = 0.0
	
	for entry in table:
		cumulative_probability += entry["probability"]
		if random_value <= cumulative_probability:
			return entry["item"]
	
	return null  # Should not happen if probabilities are set correctly
