extends Control
class_name MissionTitlerScreen

var _id := 0 
var data_titler:={}

@export var _titler :Label=null

func _ready()->void:
	_initialize_dialog()

func _initialize_dialog()->void:
	_titler.text=data_titler[_id]["titler"]
