extends Area2D

func _input_event(viewport, event, shape_idx):
	print("sdf")
	if event is InputEventMouseButton:
		print("SDf")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("A Click!")
