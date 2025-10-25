extends Node3D

@export var run := false
func _process(delta):
	if run:
		$AnimationPlayer.play("Run")
	else: 
		$AnimationPlayer.play("Idle")
