extends KinematicBody2D
class_name Ball

var velocity : Vector2 = Vector2.ZERO
export var speed : int = 10
var bounce_counter : int = 0 setget set_bounce_counter
var paused : bool = false

signal AI_point 		# emit signal when the AI scores a point
signal player_point 	# emit signal when the player scores a point
signal spawn_speed_powerup # emit signal when we should spawn the powerup

onready var arrow_sprite: Sprite = $ArrowSprite
onready var timer: Timer = $Timer
onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
onready var speedupsfx = preload("res://music/mixkit-arcade-video-game-bonus-2044.wav") 
onready var bouncesfx = preload("res://music/mixkit-player-jumping-in-a-video-game-2043.wav")

func set_bounce_counter(value : int) -> void:
	if value == 10:
		emit_signal("spawn_speed_powerup")
	bounce_counter = value

# reset the speed to 10. 
func generate_new_random_velocity() -> Vector2: 
	var x = rand_range(-1, 1)
	var y = rand_range(-1, 1)
	if x == 0:
		x += 0.1
	elif x < 0:
		x -= 0.1
	elif x > 0:
		x += 0.1
	return Vector2(x, y).normalized() * speed

func reset_position() -> void:
	
	global_position.x = 512
	global_position.y = 300
	velocity = Vector2.ZERO
	speed = 10
	bounce_counter = 0
	
	if paused == true:
		arrow_sprite.hide()
		return
	
	var new_velocity : Vector2 = generate_new_random_velocity()
	arrow_sprite.show()
	arrow_sprite.modulate = Color(1, 1, 1, 1)
	arrow_sprite.rotation = 0
	timer.start(1)
	yield(timer, "timeout")
	
	var tween = get_node("Tween")
	tween.interpolate_property(arrow_sprite, "rotation",
		0, new_velocity.angle() + 2 * PI * (randi() % 3), 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	
	timer.start(0.5)
	yield(timer, "timeout")
	
	velocity = new_velocity
	tween.interpolate_property(arrow_sprite, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _ready() -> void:
	randomize()
	reset_position()

func _physics_process(delta: float) -> void:
	if paused == true:
		return
	var result = move_and_collide(velocity)
	
	# we are not moving in a direction
	if velocity != Vector2.ZERO:
		arrow_sprite.rotation = velocity.angle()
		cpu_particles_2d.direction = -velocity.normalized()
	
	if result != null:
		arrow_sprite.hide()
		if result.collider.name == "PlayerBar" or result.collider.name == "AIBar":
			# Colliding with the paddle
			handle_collision(result)
			audio_stream_player.stream = bouncesfx
			audio_stream_player.play()
		elif result.collider.name == "AIGoal":
			emit_signal("AI_point", result)
			reset_position()
		elif result.collider.name == "PlayerGoal":
			emit_signal("player_point", result)
			reset_position()
		elif result.collider.name == "speedup":
			speed += 5
			velocity = velocity.normalized() * speed
			result.collider.queue_free()
			audio_stream_player.stream = speedupsfx
			audio_stream_player.play()
		else:
			# Colliding with top or bottom wall, Bounce off it. 
			velocity = velocity.bounce(result.normal)
			audio_stream_player.stream = bouncesfx
			audio_stream_player.play()
		set_bounce_counter(bounce_counter + 1)

func handle_collision(result : KinematicCollision2D) -> void:
	if abs(result.collider.velocity.y) < 100:
		# The paddle is not moving fast enough and is considered acting like a wall.
		# and should therefore bounce as normal
		velocity = velocity.bounce(result.normal) 
	else:
		var p1 = result.collider.global_position
		var direction : Vector2 = global_position - p1
		velocity = direction.normalized() * speed


