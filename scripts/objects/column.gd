extends CharacterBody2D
class_name Pushables

const PUSH_SPEED = 150
@export var column_id = 1
@export var active = false

func _ready():
	$AnimationPlayer.play("default")

func _physics_process(delta):
	move_and_slide()
	animation()
	velocity.y = 0
	velocity.x = 0
	
func slide_object(direction):
	velocity.x = int(direction.x)*PUSH_SPEED
	velocity.y = int(direction.y)*PUSH_SPEED

func animation():
	if active:
		$AnimationPlayer.play("active")
