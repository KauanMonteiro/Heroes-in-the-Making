extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "Olha, sério… Já tô aqui há horas esperando alguém tentar resolver isso. Eu não tenho tempo  ",
		"title": "Nelson"
	},
	1: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "pra ficar repetindo então vai logo, resolve o tal do puzzle e me deixa em paz.Não é tão difícil assim, ",
		"title": "Nelson"
	},
	2: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": " Você deve estar se perguntando sobre o botão Reiniciar. É porque os desenvolvedores sabiam que você",
		"title": "Nelson"
	},
	3: {
		"faceset":"res://assets/NPC/cat.png" ,
		"dialog": " precisaria de várias chances. Como se estivessem dizendo:'Não se preocupe, você vai precisar disso...",
		"title": "Nelson"
	},
	4: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "porque, sinceramente, eu sei que você vai encontrar aquele bug que faz a peça do puzzle ficar ",
		"title": "Nelson"
	},
	5: {
		"faceset": "res://assets/NPC/cat.png",
		"dialog": "bug que faz a peça do puzzle ficar presa no lugar erradoe eu não sei como consertar!'",
		"title": "Nelson"
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
