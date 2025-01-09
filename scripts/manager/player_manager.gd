extends Node

var life_bonus :=0
var dano_max := 1
var dano_min := 0.5
var life := 3 + life_bonus
var is_die  = false
var coins := 0

func _process(delta):
	life = min(life, 10)

