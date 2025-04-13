extends Node2D
@export_category("Animation")

@export var run_back = false
@export var run_front = false
@export var run_left = false
@export var run_right = false
var walk_end = false
@export_category("HUD")
@export var _HUD: CanvasLayer

const DIALOG_SCREEN := preload("res://scenes/UI/decision_dialog_screen.tscn")

var _dialog_data1 := {
	0: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "O que você quer?",
		"title": "Claudinei",
		"options": [
			{"text": "Eu já enfrentei aquele monstro", "result": "rota1"},
			{"text": "Precisa de ajuda no processo", "result": "rota2"},
			{"text": "Esse castelo dele é alugado também?", "result": "rota3"}
		]
	}
}

var _dialog_rota1 := {
	0: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Ele é terceirizado pela empresa 'Monstros & Cia. Ltda'. Até tem um crachá, mas o atendimento é péssimo.",
		"title": "Claudinei"
	},
	1: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "O Zarthrax contratou ele na Black Friday do Inferno. Veio com defeito, mas não quis pagar a garantia estendida.",
		"title": "Claudinei"
	},
}

var _dialog_rota2 := {
	0: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Não, vou oraganizar um processo coletivo com os zumbis",
		"title": "Rota 2",
	}
}

var _dialog_rota3 := {
	0: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Sim Todo mês vem um dragão cobrar o aluguel da masmorra!",
		"title": "Claudinei"
	},
	1: {
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "CALA A BOCA, CLAUDINHO! ISSO É... É... UMA ESTRATÉGIA DE NEGÓCIOS!",
		"title": "ZARTHRAX"
	},
	2: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Estratégia? A última cobrança veio com um aviso: 'Pague ou o portal do inferno será repossado'.",
		"title": "Claudinei"
	},
	3: {
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "EU SOU O SENHOR DAS TREVAS! NINGUÉM TIRA MEU...",
		"title": "ZARTHRAX"
	},
	4:{
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog":"..ALÔ? AH, O DRAGÃO DO SEFAZ INFERNAL...",
		"title": "ZARTHRAX"
		
	},
	5: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Viu só? Até o CAPETA tá com o nome sujo",
		"title": "Claudinei"
	}
}

var action = false
var current_dialog: DecisionDialogScreen = null

func _process(delta):
	update_animation()
	if MissionManager.devil_end_talk and !walk_end:
		$AnimationPlayer.play("walk")
		await  $AnimationPlayer.animation_finished
		walk_end = true
		
	if action and Input.is_action_just_pressed("interact")  and MissionManager.devil_end_talk:
		$CharacterBody2D/Node2D.visible = false
		show_dialog(_dialog_data1)

func show_dialog(dialog_data: Dictionary):
	for child in _HUD.get_children():
		if child is DecisionDialogScreen:
			child.queue_free()
	
	current_dialog = DIALOG_SCREEN.instantiate()
	current_dialog.data = dialog_data
	current_dialog.option_selected.connect(_on_option_selected)
	_HUD.add_child(current_dialog)
	action = false

func _on_option_selected(result: String):
	match result:
		"rota1":
			show_dialog(_dialog_rota1)
		"rota2":
			show_dialog(_dialog_rota2)
		"rota3":
			show_dialog(_dialog_rota3)

func update_animation():
	if run_back:
		$CharacterBody2D/AnimationPlayer.play("run_back")
	elif run_front:
		$CharacterBody2D/AnimationPlayer.play("run_front")
	elif run_left:
		$CharacterBody2D/AnimationPlayer.play("run_left")
	elif run_right:
		$CharacterBody2D/AnimationPlayer.play("run_right")
	else:
		$CharacterBody2D/AnimationPlayer.play("RESET")


func _ready():
	$CharacterBody2D/Node2D.visible = false
func _on_area_2d_body_entered(body):
	if body is Player and MissionManager.devil_end_talk:
		$CharacterBody2D/Node2D.visible = true
		$CharacterBody2D/Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_area_2d_body_exited(body):
	if body is Player:
		$CharacterBody2D/Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			if child is DecisionDialogScreen:
				child.queue_free()
