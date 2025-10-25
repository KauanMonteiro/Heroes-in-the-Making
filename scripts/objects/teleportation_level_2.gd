extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("deafult")


func change_scene():
	GameManager.from_scene = get_parent().name
	print("Salvando from_scene: ", GameManager.from_scene) 
	get_tree().change_scene_to_file("res://levelscenes/"+name+".tscn")

func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("action")
		await $AnimationPlayer.animation_finished
		call_deferred("change_scene")
