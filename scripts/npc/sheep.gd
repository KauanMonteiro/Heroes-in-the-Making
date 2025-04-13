extends Node2D

@export var walk2 = false

func _ready():
	$Sheep/AnimationPlayer.play("idler")
	if walk2:
		$AnimationPlayer.play("walk1")
	else:
		$AnimationPlayer.play("walk2")
