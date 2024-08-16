extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass
	
var inside = false
	
func is_body_inside():
	return inside
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("p[layer inside]")
		inside = true
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player left")
		inside = false
	InteractionManager.unregister_area(self)
