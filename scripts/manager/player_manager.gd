extends Node

# Variáveis do jogador
var life_bonus := 0
var dano_max := 1
var dano_min := 0.5
var life := 3 
var is_die := false
var coins := 0

# Calcula a vida máxima dinamicamente (base + bônus)
func get_vida_maxima() -> int:
	return 3 + life_bonus

func _process(delta):
	# Limita a vida ao máximo dinâmico, não a 10
	life = min(life, get_vida_maxima())

# Adiciona bônus de vida (chame ao coletar um coração)
func adicionar_bonus_vida(quantidade: int):
	life_bonus += quantidade
	life += quantidade  # Aumenta a vida atual junto
	print("Vida bônus atualizada:", life_bonus)  # Para debug
