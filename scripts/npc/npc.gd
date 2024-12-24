extends StaticBody2D


func _ready():
	$AnimatedSprite2D.play("default")
	$Node2D/Label.visible = false

func _on_area_2d_body_entered(body):
	if body is Player:
		$Node2D/Label.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D/Label.visible = false
