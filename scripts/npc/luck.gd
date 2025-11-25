extends Node2D

@export_category("Main Path")
enum PathSelection { NO_PATH, PATH_1, PATH_2, PATH_3 }
@export var main_path: PathSelection = PathSelection.NO_PATH

@export_category("Flip")
enum FlipSide { LEFT, RIGHT }
@export var flip_side: FlipSide = FlipSide.LEFT

func _ready() -> void:
	_update_animation_main_path()
	_flip()

func _flip() -> void:
	match flip_side:
		FlipSide.LEFT:
			$CharacterBody2D/AnimatedSprite2D.flip_h = false
		FlipSide.RIGHT:
			$CharacterBody2D/AnimatedSprite2D.flip_h = true

func _update_animation_main_path() -> void:
	match main_path:
		PathSelection.NO_PATH:
			$CharacterBody2D/AnimatedSprite2D.play("idle")
			$AnimationPlayer.stop()
		PathSelection.PATH_1:
			$CharacterBody2D/AnimatedSprite2D.play("run")
			$AnimationPlayer.play("PATH_1")
		PathSelection.PATH_2:
			$CharacterBody2D/AnimatedSprite2D.play("run")
			$AnimationPlayer.play("PATH_2")
		PathSelection.PATH_3:
			$CharacterBody2D/AnimatedSprite2D.play("run")
			$AnimationPlayer.play("PATH_3")
