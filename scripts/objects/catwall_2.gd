extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "Finalmente alguem apareceu, ja faz tempo que ninguem fala comigo",
		"title": "Jorge",
	},
	1:{
		"faceset": "",
		"dialog": "Você não é aquela parede da ilha flutuante?",
		"title": "protagoinista ",
	},
	2:{
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "Aquele e um clone barato! Os devs reciclaram meu sprite",
		"title": "jorge ",
	},
	3:{
		"faceset": "",
		"dialog": "Então você é só mais uma parede falante...",
		"title": "Protagonista",
	},
	4:{
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "Eu não sou mais uma, EU SOU A ORIGINAL!!, resolve logo esse puzzel e some daqui",
		"title": "Jorge",
	},
	
}
var action = false

func _process(delta):
	if GameManager.puzzle1 and GameManager.puzzle2 and GameManager.puzzle3:
		GameManager.puzzle1 = false
		GameManager.puzzle2 = false
		GameManager.puzzle3 = false
		queue_free()
	if action and Input.is_action_just_pressed("interact"):
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_HUD.add_child(_new_dialog)
		action = false 

func _on_area_2d_body_entered(body):
	if body is Player:
		action = true


func _on_area_2d_body_exited(body):
	if body is Player:
		action = false
		for child in _HUD.get_children():
			child.queue_free()
