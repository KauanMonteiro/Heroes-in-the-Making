extends CharacterBody2D

var player_ref = null
@onready var texture = $Sprite2D
@onready var animation = $AnimationPlayer
var attacking = false
var is_die = false
@export var life := 2
@export var damage := 1


func _on_detection_body_entered(body):
	if body is Player:
		player_ref = body

func _on_detection_body_exited(body):
	if body is Player:
		animation.play("idler")
		player_ref = null

func _physics_process(_delta):
	if player_ref != null:
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance := global_position.distance_to(player_ref.global_position)
		if distance < 65:
			attack()
		velocity = direction * 60
		die()
		animator()
		move_and_slide()


func animator():
	if !is_die:
		if !attacking:
			if velocity.x > 0:
				texture.flip_h = false
			if velocity.x < 0:
				texture.flip_h = true
			
			if velocity != Vector2.ZERO: 
				animation.play("run")
			else:
				animation.play("idler")
				

func die():
	if life <= 0:
		is_die = true
		set_physics_process(false)
		animation.play("die")
		await  animation.animation_finished
		PlayerManager.coins += randi_range(0,1)
		queue_free()

func attack():
	attacking = true
	animation.play("attack")
	await  animation.animation_finished
	attacking = false


func _on_attack_body_entered(body):
	if body is Player:
		PlayerManager.life -= damage
