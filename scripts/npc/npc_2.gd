extends StaticBody2D

var cont := 0

func _ready():
	$AnimatedSprite2D.play("default")
	$Node2D/Label.visible = false
	$Node2D2/Label.visible = false

func _on_area_2d_body_entered(body):
	if body is Player:
		cont += 1
		if cont >= 2:
			cont = 0
			$Node2D2/Label.visible = true
		else:
			$Node2D/Label.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D2/Label.visible = false
		$Node2D/Label.visible = false
