extends Node

@export var life_bonus := 0
@export var dano_max := 1
@export var dano_min := 0.5
var life := 3 + life_bonus

func _process(delta):
	life = min(life, 10)

