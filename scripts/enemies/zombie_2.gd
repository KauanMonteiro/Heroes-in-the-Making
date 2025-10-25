extends CharacterBody2D

@export var _animation_tree: AnimationTree = null
var _state_machine
var player_ref = null
var attacking = false
var is_die = false
@export var life :=1.5
var _direction: Vector2 = Vector2.ZERO  
var attack_cooldown := 1.0
var attack_timer := 0.0

func _ready():
	_state_machine = _animation_tree["parameters/playback"]
	_state_machine.travel("idle")  # fixa sempre em "idle"

func _on_detection_body_entered(body):
	if body is Player:
		player_ref = body

func _on_detection_body_exited(body):
	if body is Player:
		player_ref = null

func _physics_process(delta):
	if is_die:
		return

	if player_ref != null:
		_direction = global_position.direction_to(player_ref.global_position)
		var distance := global_position.distance_to(player_ref.global_position)

		if distance < 10:
			velocity = Vector2.ZERO
			if attack_timer <= 0:
				attack()
				attack_timer = attack_cooldown
		else:
			velocity = _direction * 60

		attack_timer -= delta
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	update_animation_direction()
	die()

func update_animation_direction():
	# Atualiza direção do blend da animação "idle"
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction

func die():
	if life <= 0:
		is_die = true
		set_physics_process(false)
		PlayerManager.coins += randi_range(0, 1)
		queue_free()

func attack():
	attacking = true
	PlayerManager.life -= 1 
	await get_tree().create_timer(0.5).timeout
	attacking = false
