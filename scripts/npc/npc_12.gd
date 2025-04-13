extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/decision_dialog_screen.tscn")
@export var _HUD: CanvasLayer
@export var _HUDTitler: CanvasLayer

const MISSIONTITLER = preload("res://scenes/UI/missiontitler.tscn")

var _titler_mission := {}
var mission_titler_instance: Control = null
var missioncomplet := false
var action := false

var _dialog_data1 := {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Preciso de ajuda um livro valioso foi roubado da minha coleção eu pago  20 moedas de ouro.",
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
		"dialog": "Muito obrigado, você cumpriu sua parte. Aqui está o pagamento, como prometido. ",
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
		if mission_titler_instance:
			mission_titler_instance.queue_free()

		if !MissionManager.mission2complet:
			_titler_mission = {
				0: {
					"titler": "Vá até o castelo e resgate o livro"
				}
			}
		else:
			_titler_mission = {
				0: {
					"titler": "Missão concluída. Fale com a Sofia para pegar sua recompensa."
				}
			}
		mission_titler_instance = MISSIONTITLER.instantiate()
		mission_titler_instance.data_titler = _titler_mission
		_HUDTitler.add_child(mission_titler_instance)
	else:
		if mission_titler_instance:
			mission_titler_instance.queue_free()
		mission_titler_instance = null

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
	else:
		pass

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
