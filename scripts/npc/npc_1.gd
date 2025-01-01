extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char2.png",
		"dialog": "Você sempre foi mais corajoso que eu,o primeiro a enfrentar a batalha.",
		"title": "Ulric"
	},
	1: {
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char2.png",
		"dialog": "Mas agora... você não está aqui.Eu deveria ter feito mais, deveria ter te protegido.",
		"title": "Ulric"
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
