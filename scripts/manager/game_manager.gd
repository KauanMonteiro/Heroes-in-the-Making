extends Node2D

var puzzle1 = false
var puzzle2 = false
var puzzle3 = false

var die_fire_slime = false

var from_scene

var last_position = null

var key = false

var inimigos_mortos_por_sala := {}

func matar_inimigo(cena: String, id: String):
	if not inimigos_mortos_por_sala.has(cena):
		inimigos_mortos_por_sala[cena] = {}
	inimigos_mortos_por_sala[cena][id] = true

func esta_morto(cena: String, id: String) -> bool:
	var morto = inimigos_mortos_por_sala.get(cena, {}).get(id, false)
	return morto

func _reload_current_scene():
	get_tree().reload_current_scene()

