extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_body_entered(body: Node2D) -> void:
	player = body

func _on_body_exited(body: Node2D) -> void:
	player = null
