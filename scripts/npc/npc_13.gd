extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "Os antigos se foram... e com eles, a verdadeira magia deste mundo."
	},
	1: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "Antes, a magia nascia da harmonia, do respeito, da vida pulsando em cada pedra e folha."
	},
	2: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "Agora... o que resta é uma sombra disso. Uma energia fria, distorcida, vinda de lugares que nem ouso nomear."
	},
	3: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "Chamam isso de poder... mas eu só vejo corrupção."
	},
	4: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "Os novos magos brincam com forças que não compreendem."
	},
	5: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "E cada feitiço deles parece apagar mais um vestígio do que fomos."
	},
	6: {
		"faceset": "",
		"title": "Sebastião",
		"dialog": "A magia de hoje... não canta. Ela grita. E eu não suporto ouvir."
	}
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


func _on_area_2d_body_entered(body):
	if body is Player:
		$Node2D.visible = true
		action = true


func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			child.queue_free()
