extends KinematicBody2D
class_name PlayerBar

var velocity : Vector2 = Vector2.ZERO
export var speed : float = 200

func _physics_process(delta: float) -> void:
	var input_vector_y = (Input.get_action_strength("ui_down") 
		- Input.get_action_strength("ui_up"))
	
	if input_vector_y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 5)
	else:
		velocity = Vector2(0, input_vector_y * speed)
#		velocity = velocity.move_toward(Vector2(0, input_vector_y * speed), 5)
	
			
	velocity = move_and_slide(velocity)

	global_position.x = 0
