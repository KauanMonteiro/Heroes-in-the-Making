extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("deafult")



func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("action")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://levelscenes/level_2.tscn")
