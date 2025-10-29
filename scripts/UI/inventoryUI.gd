extends CanvasLayer

@onready var player = get_node("../Player")
@onready var inventory = $inventory

func _ready():
	inventory.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_text_completion_replace"):
		inventory.visible = not inventory.visible
		
		if player:
			player.rolling = inventory.visible

# Adiciona item ao inventário
# item_dict = {
#   "name": String,
#   "icon": Texture,
#   "type": String ("consumable" ou "equipable"),
#   "effect": Callable (opcional),
#   "amount": int (opcional, default 1)
# }
func add_item_inventory(item_dict: Dictionary) -> bool:
	var amount_to_add = item_dict.get("amount", 1)

	# Primeiro tenta incrementar quantidade de item existente
	for slot in $inventory/Container.get_children():
		if slot.item_data.name == item_dict["name"]:
			slot.item_data.amount += amount_to_add
			slot.get_node("amount").text = str(slot.item_data.amount)
			slot.update_consume_button()
			return true

	# Se não encontrou, procura slot vazio
	for slot in $inventory/Container.get_children():
		if slot.item_data.amount == 0:
			slot.set_item(
				item_dict["name"],
				item_dict["icon"],
				amount_to_add,
				item_dict.get("type", "consumable"),
				item_dict.get("effect", null)
			)
			return true

	print("❌ Inventário cheio!")
	return false
