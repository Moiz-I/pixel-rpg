extends Control

var inv: Inv = preload("res://Entities/Inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	update_slots()
	inv.connect("update_items", update_slots)
	

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta: float) -> void:
	if DialogManager.is_dialog_active:
		self.hide()
	else:
		self.show()
