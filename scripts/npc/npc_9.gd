extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD: CanvasLayer = null

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
var mission_completed = false  

func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		
		if mission_completed:
			_new_dialog.data = _dialog_data2  
		else:
			_new_dialog.data = _dialog_data1  

		_HUD.add_child(_new_dialog)
		action = false  

func _ready():
	$Node2D.visible = false
	$AnimatedSprite2D.play("default")

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

func complete_mission():
	mission_completed = true
