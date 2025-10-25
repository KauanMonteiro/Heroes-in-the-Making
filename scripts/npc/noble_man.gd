extends Node2D
class_name NPC

@export_category("Animation")
@export var run_back := false
@export var run_front := false
@export var run_side := false

@export_category("HUD")
@export var _HUD: CanvasLayer

const MISSIONTITLER := preload("res://scenes/UI/missiontitler.tscn")
const DIALOG_SCREEN := preload("res://scenes/UI/decision_dialog_screen.tscn")
const ENEMY_SCENE := preload("res://scenes/enemies/goblin.tscn")

var action := false
var life := 10
var missioncomplet := false
var has_shown_completion_message := false
var walkend = false

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
	if MissionManager.mission3_1complet:
		queue_free()
	run_back = false
	run_front = false
	run_side = false
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
	else:
		$CharacterBody2D/AnimationPlayer.play("idler")

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
			add_enemies_to_scene()
			await $AnimationPlayer.animation_finished
			MissionManager.mission3_1complet = true
			GlobalUi.clear_mission_titler()
			queue_free()
		"nego", "nego_escolta":
			pass
			
func add_enemies_to_scene() -> void:
	var enemy_positions = [
		Vector2(1822, -270),
		Vector2(1893, -225)
	]

	for pos in enemy_positions:
		var enemy = ENEMY_SCENE.instantiate()
		enemy.position = pos
		enemy.enemy_type = "Mission3"
		get_tree().current_scene.add_child(enemy)
func update_mission_title():
	if !missioncomplet and !PlayerManager.is_die:
		if MissionManager.mission3accept:
			if !MissionManager.mission3complet:
				var titler_data = {
					0: {
						"titler": "Vá até a casa do nobre e derrote todos os monstros" 
					}
				}
				create_or_update_titler(titler_data)
			else:
				if not has_shown_completion_message:
					GlobalUi.clear_mission_titler()

					var return_message := {
						0: {
							"titler": "Volte para falar com o nobre."
						}
					}

					create_or_update_titler(return_message)
					has_shown_completion_message = true
					missioncomplet = true

func create_or_update_titler(data):
	var titler_instance = MISSIONTITLER.instantiate()
	titler_instance.data_titler = data
	GlobalUi.add_mission_titler(titler_instance)

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
		GlobalUi.clear_mission_titler()
		queue_free()
