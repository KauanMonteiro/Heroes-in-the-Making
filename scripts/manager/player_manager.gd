extends Node

var life_bonus := 0
var dano_max := 90
var dano_min := 90
var life := 3  
var is_die := false
var coins := 0

func get_vida_maxima() -> int:
	return 3 + life_bonus+ life

func _process(delta):
	life = min(life, get_vida_maxima())

func adicionar_bonus_vida(quantidade: int):
	life_bonus += quantidade
	life += quantidade
	life = min(life, get_vida_maxima())  
