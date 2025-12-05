extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_start_pressed():
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		SaveManager.load_game()
	else:
		get_tree().change_scene_to_file("res://levelscenes/level_1.tscn")



func _on_exit_pressed():
	get_tree().quit()
