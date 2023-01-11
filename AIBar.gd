extends KinematicBody2D
class_name AIBar

onready var ball: KinematicBody2D = $"../Ball"
# speed was originally 200
var speed : int = 180
var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if ball.global_position.y < global_position.y:
		if global_position.y - ball.global_position.y < 20:
			velocity = Vector2(0, -1) * (global_position.y - ball.global_position.y)
		else:
			velocity = Vector2(0, -1) * speed
	elif ball.global_position.y > global_position.y:
		if ball.global_position.y - global_position.y < 20:
			velocity = Vector2(0, 1) * (ball.global_position.y - global_position.y)
		else:
			velocity = Vector2(0, 1) * speed
	
	move_and_slide(velocity)
	
	global_position.y = clamp(global_position.y, 140, 460)
	global_position.x = 1024

