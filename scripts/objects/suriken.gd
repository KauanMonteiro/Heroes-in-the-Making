extends Node2D

@export var move1 = false
@export var move2 = false
@export var move3 = false
@export var move4 = false


func _ready():
	$CharacterBody2D/AnimatedSprite2D.play("default")
	if move1:
		$AnimationPlayer.play("action1")
	elif move2:
		$AnimationPlayer.play("action2")
	else:
		$AnimationPlayer.play("action1")
		


func _on_area_2d_body_entered(body):
	if body is Player:
		PlayerManager.life -= PlayerManager.life
