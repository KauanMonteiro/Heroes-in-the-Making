extends Node2D

func _ready():
	$Label.visible = false
func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().reload_current_scene()


func _on_area_2d_2_body_entered(body):
	if body is Player:
		$Label.visible = true

func _on_area_2d_2_body_exited(body):
	if body is Player:
		$Label.visible = false
