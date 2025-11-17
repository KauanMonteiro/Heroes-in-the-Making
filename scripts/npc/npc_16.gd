extends CharacterBody2D
class_name Npc16

var speed: float = 200.0
var min_distance: float = 25.0

@onready var target_marker: Marker2D = $"../MarkerNpc16"
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	# Se o NPC já chegou no destino em uma sessão anterior, coloca ele lá na hora!
	if MissionManager.reached_marker and target_marker:
		global_position = target_marker.global_position

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if MissionManager.reached_marker:
		move_and_slide()
		return
	
	if MissionManager.mission4_1complet:
		_go_to_marker()
		move_and_slide()
		return
	
	if MissionManager.mission4complet and player:
		var direction = player.global_position - global_position
		var distance = direction.length()
		if distance > min_distance:
			velocity = direction.normalized() * speed
	
	move_and_slide()

func _go_to_marker() -> void:
	if not target_marker:
		return
	
	var direction = target_marker.global_position - global_position
	var distance = direction.length()
	
	if distance > 5.0:
		velocity = direction.normalized() * speed
	else:
		global_position = target_marker.global_position
		velocity = Vector2.ZERO
		MissionManager.reached_marker = true
