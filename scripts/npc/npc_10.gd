extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/decision_dialog_screen.tscn")
@export var _HUD: CanvasLayer = null

var _dialog_data1: Dictionary = {
	0: {
		"faceset": 'res://assets/ui/2 Portraits with back/icons_41.png',
		"dialog": "Sou Rui, caçador da região. Cuidado com os goblins na floresta. Eles são rápidos e perigosos.",
		"title": "Rui o Caçador",
	},
	1: {
		"faceset": 'res://assets/ui/2 Portraits with back/icons_41.png',
		"dialog": "Os goblins atacam a vila e destroem tudo. Se os eliminar, a vida por aqui vai melhorar.",
		"title": "Rui o Caçador",
		"options": [
			{"text": "Eu vou derrotar os goblins", "result": "accept"},
			{"text": "Estou ocupada", "result": "decline"}
		]
	},
}

var _dialog_data2: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/icons_41.png",
		"dialog": "Fez o que prometeu. A vila está aliviada, e a floresta mais segura. Agradecemos muito.",
		"title": "Rui o Caçador",
	},
}

var action = false

func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var _new_dialog = _DIALOG_SCREEN.instantiate()
		
		# Conectar sinal antes de adicionar à árvore
		_new_dialog.option_selected.connect(_on_option_selected)
		
		# Escolher diálogo baseado no estado da missão
		if MissionManager.mission1complet:
			_new_dialog.data = _dialog_data2
		else:
			_new_dialog.data = _dialog_data1
		
		_HUD.add_child(_new_dialog)
		action = false

func _on_option_selected(result: String):
	match result:
		"accept":
			MissionManager.mission1accept = true
		"decline":
			MissionManager.mission1accept = false
		"close":
			for child in _HUD.get_children():
				if child is DecisionDialogScreen:
					child.queue_free()

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
