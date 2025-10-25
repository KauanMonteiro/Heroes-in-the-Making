extends Node2D

func _ready():
	if GameManager.from_scene != null:
		var spawn_pos = get_node_or_null(GameManager.from_scene + "Pos")
		if spawn_pos:
			$Player.global_position = spawn_pos.global_position
		else:
			print("Posição de spawn não encontrada: ", GameManager.from_scene + "Pos")

func _enter_tree():
	if GameManager.last_position:
		$Player.global_position = GameManager.last_position


