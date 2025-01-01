extends Node2D


func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().reload_current_scene()
