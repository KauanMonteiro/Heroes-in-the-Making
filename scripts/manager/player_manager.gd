extends Node

var life_bonus := 0
var dano_max := 1
var dano_min := 0.5
var life := 3  # Inicializa com a vida base
var is_die := false
var coins := 0

func get_vida_maxima() -> int:
	return 3 + life_bonus

func _ready():
	life = get_vida_maxima()  # Define a vida inicial máxima

func _process(delta):
	# Mantém a vida dentro do limite máximo
	life = min(life, get_vida_maxima())

func adicionar_bonus_vida(quantidade: int):
	life_bonus += quantidade
	life += quantidade
	life = min(life, get_vida_maxima())  # Atualiza sem exceder o máximo
