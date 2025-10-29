extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
const SHOP = preload("res://scenes/UI/shop_menu.tscn")
@export var _HUD: CanvasLayer = null

var merchant_items = [
	{
		"name": "Espada Longa",
		"price": 75,
		"desc": "Uma espada longa e resistente.",
		"icon": preload("res://assets/NPC/Gipsy/Generic demon axe.png"),
		"quantity": 10,
		"type": "equipable"
	},
	{
		"name": "Poção de Vida",
		"price": 25,
		"desc": "Restaura 50 de vida do jogador.",
		"icon": preload("res://assets/ui/75wnP9 (cópia).png"),
		"quantity": 20,
		"type": "consumable",
		"effect": "potionheal1"
	},
	{
		"name": "Poção de Velocidade",
		"price": 30,
		"desc": "Aumenta a velocidade do jogador por 10 segundos.",
		"icon": preload("res://assets/ui/Lucid-V1.2/Lucid V1.2/PNG/Flat/16/Backward.png"),
		"quantity": 15,
		"type": "consumable",
		"effect": "potionspeed1"
	}
]

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/NPC/Free Character Sprites - Fantasy Dreamland/32x32/char2.png",
		"dialog": "Seja bem-vindo à minha loja!",
		"title": "Loja do Mercador",
		"event": "open"
	},
}

var action = false
var _shop_instance: Node = null

func _ready():
	$Node2D.visible = false
	$AnimatedSprite2D.play("idle")

func _process(delta):
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		var dialog_instance: DialogScreen = _DIALOG_SCREEN.instantiate()
		dialog_instance.data = _dialog_data
		_HUD.add_child(dialog_instance)
		action = false
		dialog_instance.connect("dialog_finished", Callable(self, "_on_dialog_finished"))

func _on_dialog_finished(dialog_instance):
	for i in dialog_instance.data.values():
		if i.has("event") and i["event"] == "open":
			if _shop_instance == null:
				_shop_instance = SHOP.instantiate()
				get_tree().current_scene.add_child(_shop_instance)
				if _shop_instance.has_method("set_items"):
					_shop_instance.set_items(merchant_items)

func _on_detection_body_entered(body):
	if body is Player:
		$AnimatedSprite2D.play("entry")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("loop")
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_detection_body_exited(body):
	if body is Player:
		$AnimatedSprite2D.play("rest")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
		$Node2D.visible = false
		action = false
		for child in _HUD.get_children():
			child.queue_free()
		if _shop_instance != null:
			_shop_instance.queue_free()
			_shop_instance = null
