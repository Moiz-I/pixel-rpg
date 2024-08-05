extends Node2D
var route3_mp3 = preload("res://Assets/Music and Sounds/music/Route 3.mp3")
var national_park_mp3 = preload("res://Assets/Music and Sounds/music/National Park.mp3")
var storm_night_mp3 = preload("res://Assets/Music and Sounds/music/storm-night.ogg")
var ice_village_mp3 = preload("res://Assets/Music and Sounds/music/ice_village.mp3")
var fantasy_medieval_mp3 = preload("res://Assets/Music and Sounds/music/Fantasy Medieval.mp3")

@onready var music_player1 = $AudioStreamPlayer

var transition_time: float = 1.0


var music_dict = {
	"route3": route3_mp3,
	"national_park": national_park_mp3,
	"storm_night": storm_night_mp3,
	"ice_village": ice_village_mp3,
	"fantasy_medieval": fantasy_medieval_mp3,
}

func play_music(name: String):
	music_player1.stream = music_dict[name]
	music_player1.play()
	#match name:
		#"route3":
			#route3.play()
		#"national_park":
			#national_park.play()


func _on_route_3_finished() -> void:
	pass

func transition(song: String):
	var is_silence: bool = song=="silence"
	var next_song = music_dict[song]
	if music_player1.stream == next_song:
		return
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(music_player1, "volume_db", -50, transition_time).from(music_player1.volume_db)
	await tween.finished
	
	if !is_silence:
		music_player1.stop()
		music_player1.stream = next_song
		
		# Create a new tween for fading in
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(music_player1, "volume_db", -15, transition_time/2).from(-50)
		music_player1.play()



func _on_audio_stream_player_finished() -> void:
	music_player1.play()
