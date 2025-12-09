extends CanvasLayer

@onready var resume_btn = $menu_holder/Resume

func _ready():
	# Continua processando mesmo quando o jogo está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true


func _on_resume_pressed():
	get_tree().paused = false
	visible = false


func _on_save_pressed():
	var current_scene = get_tree().current_scene.scene_file_path
	var player_pos = $"../Player".global_position
	SaveManager.save_game(current_scene, player_pos)


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
