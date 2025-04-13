extends Node2D
class_name NPC

@export_category("Animation")
@export var run_back := false
@export var run_front := false
@export var run_side := false

@export_category("HUD")
@export var _HUD: CanvasLayer
@export var _HUDTitler: CanvasLayer

const MISSIONTITLER := preload("res://scenes/UI/missiontitler.tscn")
const DIALOG_SCREEN := preload("res://scenes/UI/decision_dialog_screen.tscn")
var _titler_mission := {}
var mission_titler_instance: Control = null
var action := false
var life := 10
var missioncomplet := false

var _dialog_data1 := {
	0: {
		"faceset": "res://assets/NPC/RPGCharactersPortraits+SpritesPack2Demo/NobleMan/Original/PortraitAndShowcase/noblemanPortrait.jpeg",
		"dialog": "Ei você... Quanto cobraria para... digamos... resolver uma situação delicada?",
		"title": "Nobre ",
		
	},
	1: {
		"faceset": "res://assets/NPC/RPGCharactersPortraits+SpritesPack2Demo/NobleMan/Original/PortraitAndShowcase/noblemanPortrait.jpeg",
		"dialog": "Meus servos foram amaldiçoados e agora vagam como mortos-vivos! Só posso oferecer 5 moedas..",
		"title": "Nobre ",
		"options": [ 
			{"text": "Eu aceito", "result": "aceito"},
			{"text": "Não sou mendigo para aceitar esmola", "result": "nego"}
		]
	}
}
var _dialog_data2 := {
	0: {
		"faceset": "res://assets/NPC/RPGCharactersPortraits+SpritesPack2Demo/NobleMan/Original/PortraitAndShowcase/noblemanPortrait.jpeg",
		"dialog": "Só irei pagar se você me escoltar até minha casa",
		"title": "Nobre",
		"options": [
			{"text": "Eu aceito", "result": "aceito_escolta"},
			{"text": "Não aceito ", "result": "nego_escolta"}
		]
	}
}

func _ready() -> void:
	$CharacterBody2D/AnimationPlayer.play("idler")
	$Node2D.visible = false

func _process(delta: float) -> void:
	update_animations()
	handle_interaction()
	update_mission_title()  

func update_animations():
	if run_back:
		$CharacterBody2D/AnimationPlayer.play("run_back")
	elif run_front:
		$CharacterBody2D/AnimationPlayer.play("run_front")
	elif run_side:
		$CharacterBody2D/AnimationPlayer.play("run_side")

func handle_interaction():
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		show_dialog()

func show_dialog() -> void:
	var new_dialog := DIALOG_SCREEN.instantiate() as DecisionDialogScreen
	
	if MissionManager.mission3complet:
		new_dialog.data = _dialog_data2
	else:
		new_dialog.data = _dialog_data1
	
	new_dialog.option_selected.connect(_on_option_selected)
	_HUD.add_child(new_dialog)
	action = false

func _on_option_selected(result: String) -> void:
	match result:
		"aceito":
			MissionManager.mission3accept = true
		"aceito_escolta":
			MissionManager.mission3_1accept = true
			$AnimationPlayer.play("walk")
		"nego", "nego_escolta":
			pass

func update_mission_title():
	if !missioncomplet and !PlayerManager.is_die:
		if mission_titler_instance:
			mission_titler_instance.queue_free()
	
	if MissionManager.mission3accept:
		var mission_text: String
		if !MissionManager.mission3complet:
			_titler_mission = {
				0: {
					"titler": "Vá até a casa do nobre e derrote os monstros %d/10" % MissionManager.monstercount
					}
				}
		else:
			_titler_mission = {
				0: {
					"titler": "Missão concluída. Fale com o nobre para pegar sua recompensa."
					}
				}
		mission_titler_instance = MISSIONTITLER.instantiate()
		mission_titler_instance.data_titler = _titler_mission
		_HUDTitler.add_child(mission_titler_instance)

func _on_area_2d_body_entered(body: Node) -> void:
	if body is Player:
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_area_2d_body_exited(body: Node) -> void:
	if body is Player:
		$Node2D.visible = false
		action = false
		close_all_dialogs()

func close_all_dialogs():
	for child in _HUD.get_children():
		if child is DecisionDialogScreen:
			child.queue_free()

func die():
	if life <= 0:
		queue_free()
