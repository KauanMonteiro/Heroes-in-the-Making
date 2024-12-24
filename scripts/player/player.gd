extends CharacterBody2D
class_name Player

var _state_machine
var attacking = false
var rolling = false
var is_die = false
@export var _animation_tree: AnimationTree = null
@export var life:= 3
@export var move_seed := 120
@export var push_speed := 10
@export var acceleration := 0.4
@export var friction := 0.8
@export var roll_cooldown := 3.0
@export var roll_speed := 150
var roll_time_left := 0.0
@export var dano_max:= 1
@export var dano_min := 0.5
func _ready():
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(delta) -> void:
	if roll_time_left > 0:
		roll_time_left -= delta

	if Input.is_action_just_pressed("attack") and !rolling:
		attack()

	if Input.is_action_just_pressed("roll") and roll_time_left <= 0 and !attacking:
		roll()

	animate()
	_move(delta)
	die()
	move_and_slide() 
	push()

func _move(_delta) -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	if rolling:
		velocity = _direction.normalized() * roll_speed
		_animation_tree["parameters/roll/blend_position"] = _direction
	else:
		if _direction != Vector2.ZERO:
			_animation_tree["parameters/idler/blend_position"] = _direction
			_animation_tree["parameters/run/blend_position"] = _direction
			_animation_tree["parameters/attack/blend_position"] = _direction
			_animation_tree["parameters/roll/blend_position"] = _direction

			velocity.x = lerp(velocity.x, _direction.normalized().x * move_seed, acceleration)
			velocity.y = lerp(velocity.y, _direction.normalized().y * move_seed, acceleration)
		else:
			velocity.x = lerp(velocity.x, _direction.normalized().x * move_seed, friction)
			velocity.y = lerp(velocity.y, _direction.normalized().y * move_seed, friction)

func animate() -> void:
	if !attacking and !rolling:
		if velocity.length() > 1:  
			_state_machine.travel("run")
		else:
			_state_machine.travel("idler")

func attack() -> void:
	attacking = true
	_state_machine.travel("attack")

func roll() -> void:
	rolling = true
	roll_time_left = roll_cooldown 
	_state_machine.travel("roll")

func _on_animation_tree_animation_finished(_attack) -> void:
	attacking = false
	rolling = false


func _on_attack_body_entered(body):
	if body.is_in_group("enemies"):
		body.life -= randf_range(dano_min,dano_max)

func die():
	is_die = true
	if life <=0:
		get_tree().reload_current_scene()

func push():
	for objects in get_slide_collision_count():
		var collision = get_slide_collision(objects)
		if collision.get_collider() is Pushables:
			collision.get_collider().slide_object(-collision.get_normal())
