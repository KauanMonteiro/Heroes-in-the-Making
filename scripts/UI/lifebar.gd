extends CanvasLayer

# Referência para o VBoxContainer da barra de vida
@onready var life_bar = $Control/VBoxContainer

# Referência ao jogador (Player)
@onready var player = PlayerManager

# A textura do coração (imagem do coração)
@onready var heart_texture = preload("res://assets/ui/75wnP9 (cópia).png")

func _ready():
	update_life_bar()

# Função para atualizar a barra de vida
func update_life_bar():
	# Limpa todos os filhos da barra de vida
	for heart in life_bar.get_children():
		heart.queue_free()

	# Cria dois HBoxContainers para as linhas superior e inferior
	var row_1 = HBoxContainer.new()
	life_bar.add_child(row_1)

	var row_2 = HBoxContainer.new()
	life_bar.add_child(row_2)

	# Adiciona os corações nas duas linhas
	for i in range(min(player.life, 10)):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		if i < 5:
			# Adiciona os primeiros 5 corações na primeira linha
			row_1.add_child(heart)
		else:
			# Adiciona os outros 5 corações na segunda linha
			row_2.add_child(heart)

func _process(delta):
	update_life_bar()
