extends StaticBody2D

const flowerEffect = preload("res://Entities/Effects/flower_effect.tscn")
const outline_shader = preload("res://outline.gdshader")  # Shader file path

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D

var mouse_inside = false

func _ready() -> void:
	interaction_area.body_entered.connect(body_has_entered)
	interaction_area.body_exited.connect(body_has_left)
	# Create a ShaderMaterial and assign the shader to it
	var material = ShaderMaterial.new()
	material.shader = outline_shader
	
	# Assign the ShaderMaterial to the sprite
	sprite.material = material
	sprite.material.set_shader_parameter("ring_count", 4)
	sprite.material.set_shader_parameter("outline_color", Color(0, 0.8, 0.8, 1))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("secondary") and mouse_inside and interaction_area.is_body_inside():
		create_grass_effect()
		queue_free()

func _on_mouse_entered() -> void:
	# Set the shader parameter using the ShaderMaterial
	mouse_inside = true
	if interaction_area.is_body_inside():
		CursorManager.set_cursor("select")
		if sprite.material is ShaderMaterial:
			sprite.material.set_shader_parameter("thickness", 0.5)
	else:
		CursorManager.set_cursor("select_disabled")

func _on_mouse_exited() -> void:
	mouse_inside = false
	CursorManager.set_cursor("default")
	# Set the shader parameter using the ShaderMaterial
	if sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("thickness", 0)

func create_grass_effect():
	var effect = flowerEffect.instantiate()
	get_parent().add_child(effect)
	effect.position = position

func body_has_entered(body: Node2D):
	if mouse_inside:
		print("body now mouse")	
		CursorManager.set_cursor("select")
		if sprite.material is ShaderMaterial:
			sprite.material.set_shader_parameter("thickness", 0.5)

func body_has_left(body: Node2D):
	if mouse_inside:
		CursorManager.set_cursor("select_disabled")
		if sprite.material is ShaderMaterial:
			sprite.material.set_shader_parameter("thickness", 0)
