extends Area2D
const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
const boss = preload("res://scenes/enemies/demon_1.tscn")
@export var _HUD: CanvasLayer = null
var action = false
var player_stop = false
var talk = true

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "MUAHAHAHA! VOCÊ CHEGOU ATÉ AQUI, MAS NINGUÉM ESCAPA DO... DO…",
		"title": "diabo"
	},
	1: {
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "qual era meu título mesmo? Ja faz tanto tempo que niguem chega aqui,",
		"title": "diabo"
	},
	2:{
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "‘Devorador de Almas Desempregadas’? ‘Senhor do Calote’? Sei lá, chefe.",
		"title": "Minotauro"
	},
	3:{
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "NINGUÉM ESCAPA DO GRANDIOSO ZARTHRAX, O DEVORADOR DE... DE TUDO!",
		"title": "ZARTHRAX"
	},
	4:{
		"faceset":"res://assets/tilesets/Evil Dungeon/purple-demon.png" ,
		"dialog": "E AGORA, MEU FIEL SERVO MINOTAURO VAI TE DESTRUIR!" ,
		"title": "ZARTHRAX"
	},
	5:{
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "Fiel? FIEL? Meu último salário veio em 1567, E meu nome é CLAUDINEI,",
		"title": "Claudinei"
	},
	6:{
		"faceset":"res://assets/tilesets/Evil Dungeon/purple-demon.png" ,
		"dialog": "Clau... Clau... CLAUDINHO! Sim! CLAUDINHO, DESTRUA ESSE INTRUSO OU TE DEMITO!" ,
		"title": "ZARTHRAX"
	},
	7: {
		"faceset": "res://assets/tilesets/Evil Dungeon/Sprite-0001.png",
		"dialog": "demite, ué. aí eu processo no tribunal infernal por danos morais. e cobro as férias acumuladas.",
		"title": "Claudinei"
	},
	8:{
		"faceset": "res://assets/tilesets/Evil Dungeon/purple-demon.png",
		"dialog": "Não se fazem funcionarios como antigamente, eu mesmo resolvo",
		"title": "ZARTHRAX"
	},
}
func _ready():
	$devil2.visible = false
	$AnimationPlayer.play("idle")

func _process(delta):
	if action and talk:
		var boss_instance = boss.instantiate()
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_HUD.add_child(_new_dialog)
		action = false 
		await _new_dialog.tree_exited
		MissionManager.devil_end_talk = true
		$AnimationPlayer.play("end")
		await $AnimationPlayer.animation_finished
		boss_instance.position= position + Vector2(0, -100)
		add_sibling(boss_instance)
		$devil2.visible = false
		$AnimationPlayer.play("idle")
		talk = false

func _on_body_entered(body):
	if body is Player and talk:
		body.set_process(false)
		body.set_physics_process(false)
		$AnimationPlayer.play("action")
		await $AnimationPlayer.animation_finished
		$devil2.visible = true
		$devil2.play("default")
		action= true
		await $AnimationPlayer.animation_finished
		body.set_process(true)
		body.set_physics_process(true)
