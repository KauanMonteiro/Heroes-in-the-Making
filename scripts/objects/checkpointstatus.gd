extends Area2D


func _on_body_entered(body):
	if body is Player:
		var player = body
		GameManager.last_position = player.global_position  
		var current_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game(current_scene, player.global_position)
