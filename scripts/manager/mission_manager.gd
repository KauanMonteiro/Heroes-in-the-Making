extends Node

#missão 1
var mission1accept = false
var goblincount := 0
var mission1complet = false
var mission1rewardGiven = false

#dugeon1
var complet_dugeon = false

#missão 2
var mission2accept = false
var mission2complet = false
var mission2rewardGiven = false
var collectedbook = false
var devil_end_talk = false

#mission3
var mission3accept = true
var mission3complet = true
var monstercount := 0
var mission3rewardGiven = false
#mission 3.1
var mission3_1accept = false
var mission3_1complet = false


func _process(delta):
	if PlayerManager.is_die:
		ResetMission()
	mission1()
	mission2()
	mission3()
	
func mission3():
	if monstercount == 107:
		mission3complet = true


func mission1():
	if goblincount == 10:
		mission1complet = true
func mission2():
	if collectedbook:
		mission2complet = true
		
func ResetMission():
	if !mission1complet:
		goblincount = 0
		PlayerManager.is_die = false
