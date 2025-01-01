extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char6.png",
		"dialog": "Sabe, tem dias em que fico aqui,parado, olhando para o nada,e me pergunto se ainda vale a pena ",
		"title": "Nia"
	},
	1: {
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char6.png",
		"dialog": "continuar.A dor que sinto, essa sensação de vazio, é por causa dela… ela foi quem me fez sentir que",
		"title": "Nia"
	},
	2:{
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char6.png",
		"dialog":"poderia ser algo mais,algo melhor. Mas agora que ela se foi,tudo o que ficou foi o buraco no peito.",
		"title": "Nia"
	},
}
var action = false

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
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
