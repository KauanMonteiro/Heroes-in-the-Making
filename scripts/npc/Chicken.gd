extends Node2D

@export var walk2 = false

func _ready():
	$Chicken/AnimationPlayer.play("idle")
	if walk2:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("walk2")
