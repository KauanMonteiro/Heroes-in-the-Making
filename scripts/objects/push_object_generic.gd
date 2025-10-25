extends CharacterBody2D
class_name PushableObject

const PUSH_SPEED = 150

func _physics_process(delta):
	move_and_slide()
	velocity.y = 0
	velocity.x = 0
	
func slide_object(direction):
	velocity.x = int(direction.x)*PUSH_SPEED
	velocity.y = int(direction.y)*PUSH_SPEED

