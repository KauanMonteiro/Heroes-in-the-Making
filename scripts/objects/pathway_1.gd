extends Area2D


func _on_body_entered(body):
	if body is Player:
		call_deferred("change_scene")

func change_scene():
	GameManager.from_scene = get_parent().name
	print("Salvando from_scene: ", GameManager.from_scene) 
	get_tree().change_scene_to_file("res://levelscenes/"+name+".tscn")
