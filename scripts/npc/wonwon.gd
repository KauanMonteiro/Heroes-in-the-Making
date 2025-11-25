extends Node2D

@export_category("Movement Direction")
enum Direction { FRONT, BACK, LEFT, RIGHT }
@export var movement_direction: Direction = Direction.FRONT

@export_category("Main Path")
enum PathSelection { NO_PATH, PATH_1, PATH_2, PATH_3 }
@export var main_path: PathSelection = PathSelection.NO_PATH

func _process(delta):
	_update_animation_movement_direction()
	_update_animation_main_path()

func _update_animation_movement_direction():
	match movement_direction:
		Direction.FRONT:
			$CharacterBody2D/AnimatedSprite2D.play("idleFront")

		Direction.BACK:
			$CharacterBody2D/AnimatedSprite2D.play("idleBack")

		Direction.LEFT:
			$CharacterBody2D/AnimatedSprite2D.flip_h = false
			$CharacterBody2D/AnimatedSprite2D.play("idleSide")

		Direction.RIGHT:
			$CharacterBody2D/AnimatedSprite2D.flip_h = true
			$CharacterBody2D/AnimatedSprite2D.play("idleSide")


func _update_animation_main_path():
	match main_path:
		PathSelection.NO_PATH:
			pass
		PathSelection.PATH_1:
			$AnimationPlayer.play("path1")

		PathSelection.PATH_2:
			$AnimationPlayer.play("path2")

		PathSelection.PATH_3:
			$AnimationPlayer.play("path3")
