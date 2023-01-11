extends Node2D

var music = preload("res://music/Waterflame - 8-bit clouds (128 kbps).mp3")
var play_point : float = 0.0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_music()

func play_music() -> void:
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()

func is_playing() -> bool:
	return $AudioStreamPlayer.is_playing()

func stop_music() -> void:
	play_point = $AudioStreamPlayer.get_playback_position()
	$AudioStreamPlayer.stop()

func resume_music() -> void: 
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play(play_point)

func toggle_music() -> void:
	$AudioStreamPlayer.set_stream_paused(!$AudioStreamPlayer.get_stream_paused())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("music_toggle"):
		MusicController.toggle_music()
		get_tree().set_input_as_handled()
