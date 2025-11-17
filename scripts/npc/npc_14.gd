extends Node2D

# ==== SISTEMA DE DIÁLOGO ====
const _DIALOG_SCREEN = preload("res://scenes/UI/dialog_screen.tscn")
@export var _HUD: CanvasLayer = null

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_02.png",
		"dialog": "Sai da frente! Tem orcs lá no campo, ",
		"title": "Aventureira"
	},
	1: {
		"faceset": "res://assets/ui/2 Portraits with back/Icons_02.png",
		"dialog": "e eles tão vindo! Se quiser viver, corre — eu não vou ficar pra ver o que acontece!.",
		"title": "Aventureira"
	},
}

var dialog_done := false
var dialog_screen: Node = null

# ==== MOVIMENTO ====
@export var speed := 60
@export var follow_distance := 80  # distância para seguir o jogador
@export var dialog_distance := 50   # distância mínima para iniciar o diálogo
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var player_ref: Node2D = null
var following_player := false
var going_to_marker := false

@onready var target_marker: Marker2D = $"../MarkerNpc14"  # ajuste conforme necessário

# ==== DETECÇÃO DO PLAYER ====
func _on_area_2d_body_entered(body):
	if body is Player:
		player_ref = body
		following_player = true  # sempre seguir o jogador quando entrar na área

func _on_area_2d_body_exited(body):
	if body is Player:
		player_ref = null
		following_player = false
		animation.play("idle")

# ==== PROCESSO PRINCIPAL ====
func _physics_process(delta):
	if player_ref and not dialog_done:
		var distance = global_position.distance_to(player_ref.global_position)
		if distance > dialog_distance:
			_follow_player(delta)  # segue o jogador só enquanto o diálogo não ocorreu
		else:
			animation.play("idle")
			_show_dialog()
	elif going_to_marker:
		_go_to_marker(delta)
	else:
		animation.play("idle")


# ==== SEGUIR O PLAYER ====
func _follow_player(delta):
	var direction = (player_ref.global_position - global_position).normalized()
	position += direction * speed * delta
	sprite.flip_h = direction.x < 0
	animation.play("run")

# ==== IR ATÉ O MARKER ====
func _go_to_marker(delta):
	if not target_marker:
		return
	
	var distance = global_position.distance_to(target_marker.global_position)
	if distance > 10:
		var direction = (target_marker.global_position - global_position).normalized()
		position += direction * speed * delta
		sprite.flip_h = direction.x < 0
		animation.play("run")
	else:
		animation.play("idle")
		going_to_marker = false
		print("NPC chegou ao marker!")

# ==== DIÁLOGO ====
func _show_dialog():
	if _HUD and not dialog_screen:
		dialog_screen = _DIALOG_SCREEN.instantiate()
		dialog_screen.data = _dialog_data
		_HUD.add_child(dialog_screen)
		dialog_screen.connect("dialog_finished", Callable(self, "_on_dialog_finished"))

# ==== QUANDO O DIÁLOGO TERMINA ====
func _on_dialog_finished(dialog_screen):
	dialog_done = true
	if dialog_screen:
		dialog_screen.queue_free()
		dialog_screen = null
	
	# Depois do diálogo, NPC vai para o marker
	following_player = false
	going_to_marker = true
	print("Diálogo terminou, indo até o marker...")

# ==== EVENTO OPCIONAL ====
func go_to_marker_after_player():
	following_player = false
	going_to_marker = true
