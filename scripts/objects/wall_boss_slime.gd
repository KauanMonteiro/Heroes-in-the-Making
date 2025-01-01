extends StaticBody2D

func _process(delta):
	if GameManager.die_fire_slime:
		queue_free()
