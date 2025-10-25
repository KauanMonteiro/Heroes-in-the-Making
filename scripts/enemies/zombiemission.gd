extends CharacterBody2D

var _state_machine
@export var _animation_tree: AnimationTree = null
var player_ref = null
var attacking = false
var is_die = false
@export var life := 2.5
var _direction: Vector2 = Vector2.ZERO  
var scene_name: String
var id_persistente: String  # Nova variável para armazenar a chave única

func _ready():
	scene_name = get_tree().current_scene.name
	# ID único baseado na posição global (ajuste o divisor para sua grade)
	id_persistente = scene_name + "_" + str(int(global_position.x / 20)) + "_" + str(int(global_position.y / 20))
	print("[Inimigo] ID Gerado: ", id_persistente)

	if GameManager.esta_morto(scene_name, id_persistente):
		print("[Inimigo] Inimigo já morto - removendo.")
		queue_free()
		return
	_state_machine = _animation_tree["parameters/playback"]
	
func _on_detection_body_entered(body):
	if body is Player:
		player_ref = body

func _on_detection_body_exited(body):
	if body is Player:
		_state_machine.travel("idle")
		player_ref = null

func _physics_process(delta):
	if player_ref != null:
		_direction = global_position.direction_to(player_ref.global_position)  
		var distance := global_position.distance_to(player_ref.global_position)
		if distance < 10:
			attack()
		velocity = _direction * 60
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
	if life <= 0 and not is_die:
		GameManager.matar_inimigo(scene_name, id_persistente)
		MissionManager.monstercount += 1
		is_die = true
		set_physics_process(false) 
		PlayerManager.coins += randi_range(0,1)
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

