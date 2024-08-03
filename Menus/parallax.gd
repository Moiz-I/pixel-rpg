extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var trees = $ParallaxBackground/trees
@onready var near_mountains = $ParallaxBackground/near_mountains
@onready var far_mountains = $ParallaxBackground/far_mountains
@onready var far_mountains2 = $ParallaxBackground/far_mountains2
@onready var near_clouds = $ParallaxBackground/near_clouds
@onready var far_clouds = $ParallaxBackground/far_clouds

@onready var sleeping = $world/Sleeping
@onready var awake = $world/Awake
@onready var frog_guy = $FrogGuy
var playerObject = preload("res://Player/player.tscn")
@onready var player = $Player

@onready var audio = $AudioStreamPlayer

@onready var keys = $keys

@export var speed_scale: float = -5

var started: bool = false

var layer_speeds = {
	"trees": 10.0,
	"near_mountains": 7.0,
	"far_mountains": 5.0,
	"far_mountains2": 6.0,
	"near_clouds": 3.0,
	"far_clouds": 1.0
}

var target_speed_scale: float = -5.0  # Initial target speed scale
var current_speed_scale: float = -5.0  # Initial current speed scale
var speed_transition_time: float = 1.0  # Time in seconds to reach the target speed
var transition_progress: float = 0.0    # Keeps track of the interpolation progress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.SPEED = 0
	animation_player.play("logo")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if the ui_accept key is pressed
	if Input.is_action_just_pressed("interact") and !started:
		started = true
		target_speed_scale = 0.0  # Set the target speed scale to 0 (idle)
		transition_progress = 0.0  # Reset the transition progress
		await get_tree().create_timer(1).timeout
		animation_player.play("start")
	
	# Gradually move towards the target speed scale
	if current_speed_scale != target_speed_scale:
		transition_progress += delta / speed_transition_time
		transition_progress = min(transition_progress, 1.0)  # Clamp to max 1.0

		# Interpolate between current_speed_scale and target_speed_scale
		current_speed_scale = lerp(current_speed_scale, target_speed_scale, transition_progress)

	# Update the parallax layer motion offset
	trees.motion_offset.x += layer_speeds["trees"] * delta * current_speed_scale
	near_mountains.motion_offset.x += layer_speeds["near_mountains"] * delta * current_speed_scale
	far_mountains.motion_offset.x += layer_speeds["far_mountains"] * delta * current_speed_scale
	far_mountains2.motion_offset.x += layer_speeds["far_mountains2"] * delta * current_speed_scale
	near_clouds.motion_offset.x += layer_speeds["near_clouds"] * delta * current_speed_scale
	far_clouds.motion_offset.x += layer_speeds["far_clouds"] * delta * current_speed_scale
	
	if player.position.y >= 175:
		SceneManager.swap_scenes(SceneRegistry.levels["game_start"],get_tree().root,self,"wipe_to_right")	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="start":
		await get_tree().create_timer(1).timeout
		await frog_guy.start_initial_dialog("start")
		sleeping.visible = false
		awake.visible = true
		await frog_guy.start_initial_dialog("start2")
		frog_guy.queue_free()
		#await get_tree().create_timer(3).timeout
		MusicPlayer.play_music("route3")
		keys.visible = true
		awake.visible = false
		player.visible = true
		player.SPEED = 140
		player.position.y = 150
		MusicPlayer.play_music("route3")
		#var player = playerObject.instantiate()
		#get_tree().root.add_child(player)
		#player.position = awake.position


func _on_audio_stream_player_finished() -> void:
	audio.play()
