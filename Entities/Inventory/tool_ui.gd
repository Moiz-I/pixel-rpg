extends Control
var sword = preload("res://Inventory/Items/tool_items/sword.tres")
var bug_net = preload("res://Inventory/Items/tool_items/bug_net.tres")
var toolInv = preload("res://Inventory/tool_inv.tres")

@onready var slot = $NinePatchRect/GridContainer/InvSlotUI

var tools = [sword, bug_net]
var tool_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toolInv.items[0] = tools[tool_index]
	slot.update(tools[tool_index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tool_switch"):
		next_tool()

func next_tool():
	tool_index = (tool_index + 1) % tools.size()
	toolInv.items[0] = tools[tool_index]
	slot.update(tools[tool_index])
