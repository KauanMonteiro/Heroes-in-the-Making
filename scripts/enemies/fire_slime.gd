extends CharacterBody2D
class_name  FireSlime

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
	if player_ref != null:
		_direction = global_position.direction_to(player_ref.global_position)  
		var distance := global_position.distance_to(player_ref.global_position)
		if distance < 50:
			attack()
		velocity = _direction * 75
		move(delta)
		die()
		animator()
		move_and_slide()

func move(_delta):
	if _direction != Vector2.ZERO:
			_animation_tree["parameters/idle/blend_position"] = _direction
			_animation_tree["parameters/run/blend_position"] = _direction
			_animation_tree["parameters/attack/blend_position"] = _direction
			_animation_tree["parameters/die/blend_position"] = _direction

func animator():
	if !is_die and !attacking:
		if velocity.length() > 1:  
			_state_machine.travel("run")
		else: 
			_state_machine.travel("idle")
			
func die():
	if life <= 0:
		is_die = true
		set_physics_process(false) 
		PlayerManager.coins += randi_range(0,15)
		_state_machine.travel("die")

func attack():
	if !attacking:
		attacking = true
		_state_machine.travel("attack")

func _on_attack_body_entered(body):
	if body is Player and attacking:
		PlayerManager.life -= 1


func _on_animation_tree_animation_finished(_die):
	if attacking:
		attacking = false
	if is_die:
		queue_free()
		GameManager.die_fire_slime = true
		

