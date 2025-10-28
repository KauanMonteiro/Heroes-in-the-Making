extends Control
class_name DialogScreen

signal dialog_finished  # Sinal emitido quando o diálogo termina

var _step := 0.05
var _id := 0
var data := {}

@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	_initialize_dialog()

func _process(delta):
	# Acelera se tecla estiver pressionada e texto ainda não terminou
	if Input.is_action_pressed("interact") and _dialog.visible_characters < 1:
		_step = 0.01
		return
	_step = 0.05

	# Avança diálogo
	if Input.is_action_just_pressed("interact"):
		_id += 1
		if _id == data.size():
			emit_signal("dialog_finished", self)  # Aqui avisamos o NPC
			queue_free()
			return
		_initialize_dialog()

func _initialize_dialog() -> void:
	if data.has(_id):
		_name.text = data[_id]["title"]
		_dialog.text = data[_id]["dialog"]
		_faceset.texture = load(data[_id]["faceset"])
		
		_dialog.visible_characters = 0
		while _dialog.visible_ratio < 1:
			await get_tree().create_timer(_step)
			_dialog.visible_characters += 1
