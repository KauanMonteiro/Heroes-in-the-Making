extends CanvasLayer

@export var player_gold: int = 100
@onready var items_container = $ItemsContainer
var custom_font = preload("res://assets/fonts/hf-free-complete/compass-pro-v1.1/CompassPro.ttf")
var current_items: Array = []

func set_items(items: Array):
	current_items = items
	_create_item_buttons()
	_create_close_button()
	_resize_buttons()

func _create_item_buttons():
	for item in current_items:
		var button := Button.new()
		button.text = item["name"] 
		button.icon = item["icon"]
		button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.expand_icon = true
		button.pressed.connect(Callable(self, "_on_item_pressed").bind(item, button))
		items_container.add_child(button)

func _create_close_button():
	var close_button := Button.new()
	close_button.text = "❌ Fechar Loja"
	close_button.pressed.connect(Callable(self, "_on_close_pressed"))
	items_container.add_child(close_button)

func _on_item_pressed(item: Dictionary, button: Button):
	for child in items_container.get_children():
		if child is HBoxContainer:
			child.queue_free()

	var submenu := HBoxContainer.new()
	submenu.alignment = BoxContainer.ALIGNMENT_CENTER
	submenu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	submenu.add_theme_constant_override("separation", 20)

	var price_label := Label.new()
	price_label.text = "Preço: %d Ouro" % item["price"]
	price_label.add_theme_font_size_override("font_size", 30)
	price_label.add_theme_font_override("font", custom_font)
	submenu.add_child(price_label)

	var desc := Label.new()
	desc.text = "%s\nQuantidade: %d" % [item["desc"], item["quantity"]]
	desc.add_theme_font_size_override("font_size", 30)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc.add_theme_font_override("font", custom_font)
	submenu.add_child(desc)

	var buy_btn := Button.new()
	buy_btn.text = "Comprar"
	buy_btn.pressed.connect(Callable(self, "_on_buy_pressed").bind(item, submenu))
	submenu.add_child(buy_btn)

	var index = items_container.get_children().find(button)
	items_container.add_child(submenu)
	items_container.move_child(submenu, index + 1)

func _on_buy_pressed(item: Dictionary, submenu: Node):
	if player_gold >= item["price"] and item["quantity"] > 0:
		player_gold -= item["price"]
		item["quantity"] -= 1
		print("✅ Comprado:", item["name"])

		var purchased_item = {
			"name": item["name"],
			"icon": item["icon"],
			"type": item.get("type", "consumable"),
			"effect": item.get("effect", null)
		}

		var inventory_node = get_tree().current_scene.get_node("inventory")
		if inventory_node:
			inventory_node.add_item_inventory(purchased_item)
	else:
		print("❌ Ouro insuficiente ou sem estoque:", item["name"])

	submenu.queue_free()

func _on_close_pressed():
	queue_free()

func _resize_buttons():
	var screen_size = get_viewport().get_visible_rect().size
	var button_width = screen_size.x * 0.45
	var button_height = screen_size.y * 0.1

	for button in items_container.get_children():
		if button is Button:
			button.custom_minimum_size = Vector2(button_width, button_height)
			button.add_theme_font_size_override("font_size", int(button_height * 0.4))

	items_container.set_anchors_preset(Control.PRESET_CENTER)
	items_container.position = screen_size / 2 - items_container.size / 2

func _ready():
	get_viewport().connect("size_changed", Callable(self, "_resize_buttons"))
