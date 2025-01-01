extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD:CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_02.png",
		"dialog": "Você me deixou,e cada dia sem você é um peso.Eu não sei como viver sem o seu sorriso.",
		"title": "Sophie"
	},
	1: {
		"faceset":"res://assets/ui/2 Portraits with back/Icons_02.png",
		"dialog": "Onde está o amor que prometemos? Onde você foi, meu querido?Por que não me leva também?",
		"title": "Sophie"
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
		action = false  # Impede que o diálogo seja instanciado múltiplas vezes


func _on_area_2d_body_entered(body):
	if body is Player:
		action = true


func _on_area_2d_body_exited(body):
	if body is Player:
		action = false
		for child in _HUD.get_children():
			child.queue_free()
