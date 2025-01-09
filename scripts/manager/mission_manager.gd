extends Node

#missão 1
var mission1accpet = false
var goblincount := 9
var mission1complet = false


func _process(delta):
	if PlayerManager.is_die:
		ResetMission()
	mission1()
	
	
func mission1():
	if goblincount == 10:
		mission1complet = true

func ResetMission():
		goblincount = 0
		PlayerManager.is_die = false
