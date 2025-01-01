extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/Main Character/icon.png",
		"dialog": "Nunca imaginei dizer isso,você era mais importante para mim do que tudo.E agora, é tarde demais.",
		"title": "Lucis Von Aldebran"
	},
	1: {
		"faceset": "res://assets/NPC/Main Character/icon.png",
		"dialog": "Queria ter falado quanto ainda estava aqui.",
		"title": "Lucis Von Aldebran"
	},
}
var action = false
func _ready():
	$AnimatedSprite2D.play("default")
func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_HUD.add_child(_new_dialog)
		action = false  


func _on_area_2d_body_entered(body):
	if body is Player:
		action = true


func _on_area_2d_body_exited(body):
	if body is Player:
		action = false
		for child in _HUD.get_children():
			child.queue_free()
