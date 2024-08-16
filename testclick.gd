extends Node2D
@onready var sprite = $Sprite2D

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sprite.get_rect().has_point(to_local(event.position)):
			print("You selected:", self.name)
