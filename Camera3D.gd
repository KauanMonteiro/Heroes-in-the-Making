extends Camera3D

@export var camera_speed = 5.0  # Velocidade de movimento da câmera
@export var mouse_sensitivity = 0.3  # Sensibilidade do mouse

var pitch = 0.0
var yaw = 0.0
var last_mouse_position = Vector2.ZERO

func _ready():
	# Torna o ponteiro do mouse visível, mas confinado dentro da janela
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	# Armazena a posição inicial do mouse
	last_mouse_position = get_viewport().get_mouse_position()

func _process(delta):
	# Movimento da câmera com as teclas WASD
	var move_dir = Vector3.ZERO

	if Input.is_action_pressed("ui_left"):
		move_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_dir.x += 1
	if Input.is_action_pressed("ui_up"):
		move_dir.z -= 1
	if Input.is_action_pressed("ui_down"):
		move_dir.z += 1
	
	move_dir = move_dir.normalized() * camera_speed * delta
	translate(move_dir)

	# Movimento da câmera com o mouse
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_delta = mouse_position - last_mouse_position
	last_mouse_position = mouse_position

	# Atualiza o ângulo da câmera
	yaw -= mouse_delta.x * mouse_sensitivity
	pitch = clamp(pitch - mouse_delta.y * mouse_sensitivity, -90.0, 90.0)

	# Aplica a rotação à câmera
	rotation_degrees = Vector3(pitch, yaw, 0)
