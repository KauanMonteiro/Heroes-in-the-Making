extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD: CanvasLayer = null

# Diálogos para a primeira interação (missão não completa)
var _dialog_data1: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Você não é daqui. A vila era cheia de vida, mas agora... restam poucos de nós, escondidos e com medo.",
		"title": "Günter"
	},
	1: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Eu lutei, garota. Lutamos todos. Mas no final, o que sobrou? Poucos de nós, com medo, tentando sobreviver.",
		"title": "Günter"
	},
	2: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Eu era forte, menina. Agora... sou só um velho, com saudade e medo do que virá.",
		"title": "Günter"
	},
	3: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png",  
		"dialog": "Você não entende. A luta que você quer... não é pra alguém como você. Não há mais forças.",
		"title": "Günter"
	},
	4: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Você acha que pode enfrentar os goblins? Eu fui um dos melhores, e até eu já não tenho forças.",
		"title": "Günter"
	}
}



# Diálogos para a segunda interação (missão completa)
var _dialog_data2: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png", 
		"dialog": "Hmph... Você fez o que prometeu, né? Os monstros não são mais um problema,",
		"title": "Günter"
	},
	1:{
		"faceset": "res://assets/ui/2 Portraits with back/Icons_13.png",  
		"dialog":" mas não se engane. Isso não vai durar. A vila tem um pouco de paz agora,",
		"title": "Günter"
		
	},
}


var action = false
var mission_completed = false  

func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		
		if mission_completed:
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
			
func complete_mission():
	mission_completed = true
