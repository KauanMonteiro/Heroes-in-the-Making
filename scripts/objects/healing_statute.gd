extends StaticBody2D

var bonus = 2
var is_bonus = false
var action = false

func _on_area_body_entered(body):
	if body is Player:
		$Node2D/Label.visible = true
		if !is_bonus:
			is_bonus = true
			action = true
			
func _process(delta):
	if is_bonus and action and Input.is_action_just_pressed("interact"):
		PlayerManager.life += bonus
		action = false


func _on_area_body_exited(body):
	if body is Player:
		$Node2D/Label.visible = false
		
