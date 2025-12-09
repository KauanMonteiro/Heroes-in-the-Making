extends CharacterBody2D
class_name Player

var _state_machine
var attacking := false
var rolling := false

@export var _animation_tree: AnimationTree = null
@export var move_speed := 180.0
@export var roll_speed := 250.0      
@export var acceleration := 1.0
@export var friction := 1.0
@export var roll_cooldown := 0.6     
@export var roll_duration := 1  

var roll_time_left := 0.0
var attack_timer := 0.0
var roll_direction := Vector2.ZERO

func _ready() -> void:
	_state_machine = _animation_tree["parameters/playback"]
	_animation_tree.active = true
	
	# ← IMPORTANTE: conecta o sinal
	_animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)

func _physics_process(delta: float) -> void:
	# ← ROLL: força parar se timer acabar
	if roll_time_left > 0:
		roll_time_left -= delta
		velocity = roll_direction * roll_speed
	else:
		if rolling:
			rolling = false  # ← FORÇA PARAR AQUI!
			velocity = velocity.move_toward(Vector2.ZERO, move_speed * 10 * delta)
	
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attacking = false
	
	if Input.is_action_just_pressed("attack") and !rolling and !attacking:
		attack()
	
	if Input.is_action_just_pressed("roll") and roll_time_left <= 0 and !attacking:
		roll()
	
	animate()
	_move(delta)
	die()
	move_and_slide()
	push()

func _move(_delta: float) -> void:
	var input_dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	var mouse_dir := (get_global_mouse_position() - global_position).normalized()
	
	# Atualiza animações pro mouse (sempre)
	_animation_tree["parameters/idler/blend_position"] = mouse_dir
	_animation_tree["parameters/run/blend_position"] = mouse_dir
	_animation_tree["parameters/attack/blend_position"] = mouse_dir
	_animation_tree["parameters/roll/blend_position"] = mouse_dir
	
	# ← SÓ move NORMAL se NÃO estiver rolando
	if !rolling:
		if input_dir != Vector2.ZERO:
			velocity.x = lerp(velocity.x, input_dir.x * move_speed, acceleration)
			velocity.y = lerp(velocity.y, input_dir.y * move_speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.y = lerp(velocity.y, 0.0, friction)

func animate() -> void:
	if attacking or rolling:
		return
	
	if velocity.length() > 10:
		_state_machine.travel("run")
	else:
		_state_machine.travel("idler")

func attack() -> void:
	attacking = true
	attack_timer = 0.5
	_state_machine.travel("attack")

# ← ROLL SIMPLIFICADO E PERFEITO
func roll() -> void:
	var input_dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	roll_direction = input_dir if input_dir != Vector2.ZERO else (get_global_mouse_position() - global_position).normalized()
	
	rolling = true
	roll_time_left = roll_duration  # 0.10s = MUITO CURTO
	
	_state_machine.travel("roll")

# ← AGORA FUNCIONA 100%
func _on_animation_tree_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		attacking = false
		attack_timer = 0.0
	elif anim_name == "roll":
		rolling = false  # ← FORÇA PARAR TAMBÉM AQUI (dupla segurança)

func _on_attack_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.life -= randf_range(PlayerManager.dano_min, PlayerManager.dano_max)

func die() -> void:
	if PlayerManager.life <= 0:
		PlayerManager.is_die = true
		PlayerManager.life = PlayerManager.get_vida_maxima()
		get_tree().reload_current_scene()

func push() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is PushableObject or collider is PushableObjectPuzzle:
			collider.slide_object(-collision.get_normal())
