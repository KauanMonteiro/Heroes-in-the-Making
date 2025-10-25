extends Area2D

@export var key = false

func _ready():
	$Node2D/Label.visible = false

func _on_body_entered(body):
	if key:
		if body is Player and GameManager.key:
			call_deferred("change_scene")
	else:
		if body is Player:
			call_deferred("change_scene")

func change_scene():
	GameManager.from_scene = get_parent().name
	print("Salvando from_scene: ", GameManager.from_scene)
	get_tree().change_scene_to_file("res://levelscenes/"+name+".tscn")

func _on_area_2d_body_entered(body):
	if key and body is Player and !GameManager.key:
		$Node2D/Label.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D/Label.visible = false
