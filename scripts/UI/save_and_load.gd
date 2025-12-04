extends CanvasLayer

func _on_save_pressed():
	var current_scene = get_tree().current_scene.scene_file_path
	var player_pos = $"../Player".global_position
	SaveManager.save_game(current_scene, player_pos)

func _on_load_pressed():
	SaveManager.load_game()
