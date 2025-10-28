extends StaticBody2D

const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
const SHOP = preload("res://scenes/UI/shop_menu.tscn")
@export var _HUD: CanvasLayer = null

var merchant_items = [
	{
		"name": "Espada Longa",
		"price": 75,
		"desc": "Uma espada longa e resistente, perfeita para aventureiros.",
		"icon": preload("res://assets/NPC/Gipsy/Generic demon axe.png"),
		"quantity": 10  # Quantidade de itens disponíveis
	},
	{
		"name": "Escudo de Ferro",
		"price": 50,
		"desc": "Um escudo sólido que protege contra ataques frontais.",
		"icon": preload("res://assets/NPC/Gipsy/Generic demon axe.png"),
		"quantity": 5  # Quantidade de itens disponíveis
	},
	{
		"name": "Poção de Vida",
		"price": 25,
		"desc": "Restaura parte da vida do jogador.",
		"icon": preload("res://assets/NPC/Gipsy/Generic demon axe.png"),
		"quantity": 20  # Quantidade de itens disponíveis
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
var _shop_instance: Node = null  # Instância do shop

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

		# Conecta o sinal de fim de diálogo
		dialog_instance.connect("dialog_finished", Callable(self, "_on_dialog_finished"))

func _on_dialog_finished(dialog_instance):
	# Abre o shop apenas quando o diálogo terminar
	for i in dialog_instance.data.values():
		if i.has("event") and i["event"] == "open":
			if _shop_instance == null:
				_shop_instance = SHOP.instantiate()
				get_tree().current_scene.add_child(_shop_instance)

				# Envia os itens do NPC para o shop
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
		# Fecha o shop se estiver aberto
		if _shop_instance != null:
			_shop_instance.queue_free()
			_shop_instance = null
