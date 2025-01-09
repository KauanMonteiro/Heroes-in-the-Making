extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD: CanvasLayer = null
@export var _HUDTitler: CanvasLayer = null

const MISSIONTITLER = preload("res://scenes/UI/missiontitler.tscn")

var _titler_mission: Dictionary = {} 

var _dialog_data1: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Ah, uma nova aventureira em busca de fama, não é? Tenho uma missão para você.",
		"title": "Lúcia"
	},
	1: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Goblins estão atacando na floresta. Elimine-os para deixar a vila segura.",
		"title": "Lúcia"
	},
}

var _dialog_data2: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_16.png",
		"dialog": "Você completou a missão! A vila está segura agora. Obrigada!",
		"title": "Lúcia"
	},
}

var action = false
var mission_titler_instance: MissionTitlerScreen = null  # Para armazenar a instância atual do título
var missioncomplet = false
func update_mission_title():
	if !missioncomplet:
		if mission_titler_instance:
			mission_titler_instance.queue_free()

		if !MissionManager.mission1complet:
			_titler_mission = {
				0: {
					"titler": "Elimine os Goblins na Floresta: " + str(MissionManager.goblincount) + "/10"
				}
			}
		else:
			_titler_mission = {
				0: {
					"titler": "Missão concluída. 
					Fale com a Lucia para pegar sua recompensa."
				}
			}

		# Cria uma nova instância do título da missão
		mission_titler_instance = MISSIONTITLER.instantiate()
		mission_titler_instance.data_titler = _titler_mission
		_HUDTitler.add_child(mission_titler_instance)
	else:
		if mission_titler_instance:
			mission_titler_instance.queue_free()
		mission_titler_instance = null

func _process(delta):
	if MissionManager.mission1accpet:
		update_mission_title()

	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		MissionManager.mission1accpet = true
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()

		if MissionManager.mission1complet:
			_new_dialog.data = _dialog_data2
			PlayerManager.coins += 1000
			missioncomplet = true
		else:
			_new_dialog.data = _dialog_data1  

		_HUD.add_child(_new_dialog)
		action = false  

# Inicialização
func _ready():
	$Node2D.visible = false
	$AnimatedSprite2D.play("default")

# Detecção de colisão com o player
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
