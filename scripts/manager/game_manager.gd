extends Node2D

var puzzle1 = false
var puzzle2 = false
var puzzle3 = false

var die_fire_slime = false

var from_scene

var last_position = null

func respawn_at_checkpoint():
	if last_position:
		global_position = last_position
		call_deferred("_reload_current_scene")

func _reload_current_scene():
	get_tree().reload_current_scene()
	
