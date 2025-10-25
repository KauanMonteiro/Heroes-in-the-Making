extends CharacterBody2D

# =========================================================
# CONFIGURAÇÕES DO INIMIGO
# =========================================================
@export_enum("Normal", "Mission3") var enemy_type: String = "Normal"
@export var life: int = 2
@export var damage: int = 1
@export var move_speed: float = 60.0

# =========================================================
# REFERÊNCIAS E ESTADOS
# =========================================================
@onready var texture:= $Sprite2D
@onready var animation:= $AnimationPlayer
var nobleman: Node = null

var player_ref: Node = null
var attacking:= false
var is_die:= false

# =========================================================
# DETECÇÃO DE ALVOS
# =========================================================
func _on_detection_body_entered(body: Node) -> void:
	if enemy_type == "Normal" and body is Player:
		player_ref = body
	elif enemy_type == "Mission3" and body.is_in_group("nobleman"):
		player_ref = body

func _on_detection_body_exited(body: Node) -> void:
	if (enemy_type == "Normal" and body is Player) or (enemy_type == "Mission3" and body.is_in_group("nobleman")):
		player_ref = null
		animation.play("idler")

# =========================================================
# LOOP PRINCIPAL
# =========================================================
func _physics_process(_delta: float) -> void:
	# Garante que o nobre seja encontrado
	if enemy_type == "Mission3" and nobleman == null:
		nobleman = get_tree().get_first_node_in_group("nobleman")
		if nobleman:
			player_ref = nobleman

	if player_ref != null and !is_die:
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)

		# Ataca se estiver próximo
		if distance < 30 and !attacking:
			attack()
		elif !attacking:
			velocity = direction * move_speed
		else:
			velocity = Vector2.ZERO  # para de andar ao atacar

		animator()
		die()
		move_and_slide()

# =========================================================
# ANIMAÇÕES
# =========================================================
func animator() -> void:
	if is_die:
		return

	if !attacking:
		if velocity.x > 0:
			texture.flip_h = false
		elif velocity.x < 0:
			texture.flip_h = true

		if velocity.length() > 1:
			animation.play("run")
		else:
			animation.play("idler")

# =========================================================
# MORTE DO INIMIGO
# =========================================================
func die() -> void:
	if life <= 0 and !is_die:
		is_die = true
		set_physics_process(false)
		animation.play("die")
		await animation.animation_finished
		PlayerManager.coins += randi_range(0, 1)
		queue_free()

# =========================================================
# ATAQUE
# =========================================================
func attack() -> void:
	attacking = true
	velocity = Vector2.ZERO
	animation.play("attack")
	await animation.animation_finished
	attacking = false

# =========================================================
# DANO AO CONTATO DE ATAQUE
# =========================================================
func _on_attack_body_entered(body) -> void:
	if is_die:
		return

	if body is Player:
		PlayerManager.life -= damage
	elif enemy_type == "Mission3":
		# Checa se o corpo é o NobleMan
		var noble_root = body
		# Sobe um nível caso body seja uma área ou nó filho
		if not (noble_root is NPC) and noble_root.get_parent() is NPC:
			noble_root = noble_root.get_parent()
		
		if noble_root is NPC:
			noble_root.life -= damage
			print("Goblin atacou o nobre! Vida restante:", noble_root.life)
			if noble_root.life <= 0:
				noble_root.die()

