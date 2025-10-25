extends Area2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "",
		"dialog": "Aos meus pais,Escrevo às pressas, enquanto as chamas consomem o que restou de nosso lar. ",
		"title": "Carta"
	},
	1: {
		"faceset":"",
		"dialog":"A mansão da família, que por séculos resistiu a invasões e pragas, rui sob o peso de minha arrogância.",
		"title":"carta"
	},
	2:{
		"faceset":"",
		"dialog":"Tentei restaurar nossa fortuna com um pacto antigo, encontrado nas catacumbas esquecidas.",
		"title":"carta"
	},
	3:{
		"faceset":"",
		"dialog":"Prometi aos espíritos das sombras um exército de servos em troca de poder.Mas os mortos que levantei ",
		"title":"carta"
	},
	4:{
		"faceset":"",
		"dialog":"não são guerreiros...são monstros. Criaturas sem mente, que destroem tudo em seu caminho ",
		"title":"carta"
	},
	5:{
		"faceset":"",
		"dialog":"O ritual falhou. As criaturas viraram-se contra mim, e o demônio que invoquei para controlá-las fugiu, ",
		"title":"carta"
	},
	6:{
		"faceset":"",
		"dialog":"deixando apenas caos. Nossos salões estão infestados de zumbis.",
		"title":"carta"
	},
	7:{
		"faceset":"",
		"dialog":"Sou o culpado. Não soube governar, nem honrar nosso nome. Usei magia que não entendia, ",
		"title":"carta"
	},
	8:{
		"faceset":"",
		"dialog":"convencido de que poderia superar até a maldição de nossos ancestrais. Agora, pago o preço.",
		"title":"carta"
	},
	9:{
		"faceset":"",
		"dialog":"Assinado,
Seu filho",
		"title":"carta"
	},

}
var action = false

func _ready():
	$Node2D.visible = false
	
func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_HUD.add_child(_new_dialog)
		action = false 

func _on_body_entered(body):
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_body_exited(body):
	if body is Player:
		$Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			child.queue_free()
