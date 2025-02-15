extends StaticBody2D
const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
const boss = preload("res://scenes/enemies/demon_1.tscn")
@export var _HUD: CanvasLayer = null
var action = false
var player_stop = false
var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/enemies/dark_character_1/summon.png",
		"dialog": "Você ousou invadir meu templo... agora pagará o preço.",
		"title": "Mago"
	},
	1: {
		"faceset": "res://assets/enemies/dark_character_1/summon.png",
		"dialog": " As trevas que controlei por tanto tempo vão se libertar!",
		"title": "Mago"
	},
}
func _ready():
	$summon1.play("init")

func _process(delta):
	if action:
		var boss_instance = boss.instantiate()
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_HUD.add_child(_new_dialog)
		action = false
		await _new_dialog.tree_exited
		$summon1.play("summon")
		await $summon1.animation_finished
		boss_instance.position= position + Vector2(0, -100)
		add_sibling(boss_instance)
		$summon1.play("teleport2")
		player_stop = true
		await $summon1.animation_finished
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Player:
		body.set_process(false)
		body.set_physics_process(false)
		action = true
		$summon1.play("teleport")
		await $summon1.animation_finished
		$summon1.play("idler")
		await $summon1.animation_finished
		body.set_process(true)
		body.set_physics_process(true)
