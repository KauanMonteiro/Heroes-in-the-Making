extends CharacterBody2D

var _state_machine
@export var _animation_tree: AnimationTree = null
var player_ref = null
var attacking = false
var is_die = false
@export var life := 3
var _direction: Vector2 = Vector2.ZERO

func _ready():
	_state_machine = _animation_tree["parameters/playback"]
	
func _on_detection_body_entered(body):
	if body is Player:
		player_ref = body

func _on_detection_body_exited(body):
	if body is Player:
		player_ref = null

func _physics_process(delta):
	if player_ref != null && !is_die:
		_direction = global_position.direction_to(player_ref.global_position)
		var distance := global_position.distance_to(player_ref.global_position)
		
		if distance <= 75:
			attack()
		velocity = _direction * 60
		move(delta)
		animator()
		move_and_slide()
	
	die()

func move(_delta):
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idler/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction

func animator():
	if !is_die && !attacking:
		_state_machine.travel("idler")
			
func die():
	if life <= 0 && !is_die:
		is_die = true
		set_physics_process(false)
		PlayerManager.coins += randi_range(0,15)
		_state_machine.travel("die")
		

func attack():
	if !attacking && !is_die:
		attacking = true
		_state_machine.travel("attack")

func _on_attack_body_entered(body):
	if body is Player and attacking:
		PlayerManager.life -= 1

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "attack":
		attacking = false
	elif anim_name == "die":
		MissionManager.complet_dugeon = true
		PlayerManager.adicionar_bonus_vida(1)
		queue_free()
