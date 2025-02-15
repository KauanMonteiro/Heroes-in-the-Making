extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD: CanvasLayer = null

# Diálogos para a primeira interação (missão não completa)
var _dialog_data1: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Você não é daqui. Não venha me importunar com os seus problemas.",
		"title": "Günter"
	},
	1: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Eu lutei muito em minha juventude. Agora só quero ficar em paz",
		"title": "Günter"
	},

	2: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png",  
		"dialog": "Você acha que pode enfrentar os goblins? Isso não é pra alguém como você.",
		"title": "Günter"
	},
}

var _dialog_data2: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Hm... Então, derrotou os goblins, é? Parece que os monstros não representam mais uma ameaça",
		"title": "Günter"
	}
}



var action = false

func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		
		if MissionManager.mission1complet:
			_new_dialog.data = _dialog_data2  
		else:
			_new_dialog.data = _dialog_data1  

		_HUD.add_child(_new_dialog)
		action = false  

func _ready():
	$Node2D.visible = false
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body):
	if body is Player:
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			child.queue_free()
			
