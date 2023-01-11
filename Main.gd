extends Node2D
class_name Main

var player_score : int = 0
var ai_score : int = 0

onready var playernumber: Label = $"%Playernumber"
onready var ainumber: Label = $"%AInumber"
onready var goalparticles: CPUParticles2D = $goalparticles
onready var ball: KinematicBody2D = $Ball
var speedup = preload("res://speedup.tscn")
onready var timer: Timer = $Timer
onready var game_end: Control = $CanvasLayer/GameEnd
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var goalsfx = preload("res://music/boom2.wav")

func _ready() -> void:
	playernumber.text = str(player_score)
	ainumber.text = str(ai_score)

func _on_Ball_AI_point(result : KinematicCollision2D) -> void:
	# AI has scored a point
	if get_node_or_null("speedup") != null:
		get_node("speedup").queue_free()
	ai_score += 1
	ainumber.text = str(ai_score)
	audio_stream_player.stream = goalsfx
	audio_stream_player.play()
	if ai_score >= 5:
		game_end.show()
		game_end.set_text("Computer wins!")
		ball.paused = true
		goalparticles.global_position = result.position
		goalparticles.rotation_degrees = 0
		goalparticles.emitting = true
		timer.start(3)
		yield(timer, "timeout")
		game_end.set_text("Thank you for playing!")
		timer.start(3)
		yield(timer, "timeout")
		
		get_tree().change_scene_to(load("res://TitleScreen.tscn"))
		
		
#	goalparticles.global_position.x = 0
#	goalparticles.global_position.y = 300
	goalparticles.global_position = result.position
	goalparticles.rotation_degrees = 0
	goalparticles.emitting = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to(load("res://TitleScreen.tscn"))
		get_tree().set_input_as_handled()


func _on_Ball_player_point(result : KinematicCollision2D) -> void:
	# player has scored a point
	if get_node_or_null("speedup") != null:
		get_node("speedup").queue_free()
	player_score += 1
	playernumber.text = str(player_score)
	audio_stream_player.stream = goalsfx
	audio_stream_player.play()
	if player_score >= 5:
		game_end.show()
		game_end.set_text("You Win!")
		ball.paused = true
		goalparticles.global_position = result.position
		goalparticles.rotation_degrees = 180
		goalparticles.emitting = true
		timer.start(3)
		yield(timer, "timeout")
		game_end.set_text("Thank you for playing!")
		timer.start(3)
		yield(timer, "timeout")
		get_tree().change_scene_to(load("res://TitleScreen.tscn"))
	
#	goalparticles.global_position.x = 1024
#	goalparticles.global_position.y = 300
	goalparticles.global_position = result.position
	goalparticles.rotation_degrees = 180
	goalparticles.emitting = true


func _on_Ball_spawn_speed_powerup() -> void:
	var instance = speedup.instance()
	add_child(instance)
	instance.name = "speedup"
	instance.global_position.x = 512
	instance.global_position.y = rand_range(150, 450)

