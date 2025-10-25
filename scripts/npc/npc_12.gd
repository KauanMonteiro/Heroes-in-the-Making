extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/decision_dialog_screen.tscn")
const MISSIONTITLER = preload("res://scenes/UI/missiontitler.tscn")

@export var _HUD: CanvasLayer

var mission_titler_instance: Control = null
var missioncomplet := false
var action := false

var _dialog_data1 := {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Preciso de ajuda um livro valioso foi roubado da minha coleção eu pago 20 moedas de ouro.",
		"title": "Sofia",
	},
	1: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "você aceita?",
		"title": "Sofia",
		"options": [
			{"text": "Aceitar missão", "result": true},
			{"text": "Recusar", "result": false}
		]
	},
}

var _dialog_data2 := {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Muito obrigado, você cumpriu sua parte. Aqui está o pagamento, como prometido.",
		"title": "Sofia"
	},
}

func _ready() -> void:
	$Node2D.visible = false
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	if MissionManager.mission2accept:
		update_mission_title()

	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		show_dialog()

func update_mission_title():
	if !missioncomplet and !PlayerManager.is_die:
		clear_existing_titler()
		
		var titler_data = {
			0: {"titler": "Vá até o castelo e resgate o livro"} if !MissionManager.mission2complet else 
			   {"titler": "Missão concluída. Fale com a Sofia para pegar sua recompensa."}
		}
		
		create_new_titler(titler_data)
	else:
		clear_existing_titler()

func clear_existing_titler():
	if mission_titler_instance:
		mission_titler_instance.queue_free()
		mission_titler_instance = null

func create_new_titler(data):
	mission_titler_instance = MISSIONTITLER.instantiate()
	mission_titler_instance.data_titler = data
	GlobalUi.add_mission_titler(mission_titler_instance)

func show_dialog() -> void:
	var new_dialog := _DIALOG_SCREEN.instantiate() as DecisionDialogScreen
	
	if MissionManager.mission2complet:
		new_dialog.data = _dialog_data2
		if !MissionManager.mission2rewardGiven:
			PlayerManager.coins += 20
			PlayerManager.get_vida_maxima()
			MissionManager.mission2rewardGiven = true
			missioncomplet = true
	else:
		new_dialog.data = _dialog_data1
		new_dialog.option_selected.connect(_on_option_selected)

	_HUD.add_child(new_dialog)
	action = false

func _on_option_selected(result) -> void:
	if result:
		MissionManager.mission2accept = true
		update_mission_title()

func _on_area_2d_body_entered(body) -> void:
	if body is Player:
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_area_2d_body_exited(body) -> void:
	if body is Player:
		$Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			if child is DecisionDialogScreen:
				child.queue_free()
