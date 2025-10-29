extends Control

var item_data = {
	"name": "",
	"texture": null,
	"amount": 0,
	"type": "",
	"effect": null
}

var is_selected = false
@onready var consume_button = $btn_consume
func _ready():
	# Inicialmente o botão está oculto
	$btn_consume.hide()

func _get_drag_data(at_position):
	var data := {
		"sprite": $sprite.texture,
		"amount": $amount.text,
		"backup": self,
		"item_data": item_data
	}

	var preview := self.duplicate() 
	preview.get_node("background").hide()
	preview.get_node("amount").hide()
	preview.get_node("sprite").position = -preview.size / 2 

	set_drag_preview(preview)
	set_empty_slot()
	return data

func set_empty_slot()->void:
	$sprite.texture = null
	$amount.text = ''
	# Limpa os dados do item
	item_data = {
		"name": "",
		"texture": null,
		"amount": 0,
		"type": "",
		"effect": null
	}
	# Esconde o botão quando o slot está vazio
	$btn_consume.hide()
	is_selected = false

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	if $sprite.texture == data.sprite:
		var drop_item = int($amount.text)
		drop_item += int(data.amount)
		$amount.text = str(drop_item)
		# Atualiza dados do item
		item_data.amount = drop_item
	else:
		# Troca os dados dos itens
		data.backup.item_data = item_data.duplicate()
		data.backup.get_node("sprite").texture = $sprite.texture
		data.backup.get_node("amount").text = $amount.text
		
		item_data = data.item_data.duplicate()
		$sprite.texture = data.sprite
		$amount.text = data.amount
	
	# Desseleciona após o drop
	deselect_item()

# NOVAS FUNÇÕES PARA O SISTEMA DE EFEITOS

# Função para consumir item
func _on_btn_consume_pressed():
	if item_data.amount > 0:
		item_data.amount -= 1
		$amount.text = str(item_data.amount)
		
		# Executa efeito via singleton
		if item_data.effect != null and EffectManager != null:
			EffectManager.instance.executar_efeito(item_data.effect)
		
		# Remove item se acabar
		if item_data.amount <= 0:
			set_empty_slot()
		else:
			# Mantém selecionado se ainda tem itens
			select_item()

# Função para selecionar o item (quando clicar no slot)
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $sprite.texture != null:  # Só seleciona se tem item
			if is_selected:
				deselect_item()
			else:
				select_item()

# Seleciona item - mostra o botão de consumir
func select_item():
	if item_data.type == "consumable" and item_data.amount > 0:
		$btn_consume.show()
		is_selected = true

# Desseleciona item - esconde o botão de consumir
func deselect_item():
	$btn_consume.hide()
	is_selected = false

# Define os dados do item no slot
func set_item(name: String, texture: Texture2D, amount: int, type: String, effect = null):
	item_data.name = name
	item_data.texture = texture
	item_data.amount = amount
	item_data.type = type
	item_data.effect = effect
	
	$sprite.texture = texture
	$amount.text = str(amount)
	
	# Ao adicionar item, não mostra o botão automaticamente
	deselect_item()
func update_consume_button():
	if item_data.type == "consumable" and item_data.amount > 0:
		consume_button.disabled = false
	else:
		consume_button.disabled = true
