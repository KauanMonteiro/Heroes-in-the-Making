extends StaticBody2D

@export var life := 3

func _physics_process(delta) -> void:
	die()
	
func die():
	if life <= 0:
		queue_free()
