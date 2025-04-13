extends Sprite2D

func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("action")
		await  $AnimationPlayer.animation_finished
		call_deferred("change_scene")

func change_scene():
	GameManager.from_scene = get_parent().name
	print("Salvando from_scene: ", GameManager.from_scene) 
	get_tree().change_scene_to_file("res://levelscenes/"+name+".tscn")
