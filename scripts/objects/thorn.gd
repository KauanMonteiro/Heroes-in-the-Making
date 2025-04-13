extends Node2D



func _on_area_2d_body_entered(body):
	if body is Player:
		PlayerManager.life -= PlayerManager.life


func _on_area_2d_2_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("action")
