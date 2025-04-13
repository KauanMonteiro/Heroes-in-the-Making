extends Control
class_name DecisionDialogScreen
signal option_selected(result)

var _step := 0.05
var _id := 0
var data := {}
var is_waiting_choice := false

@export var _name: Label
@export var _dialog: RichTextLabel
@export var _faceset: TextureRect
@export var _options_container: VBoxContainer
@export var _option_button_template: Button 

func _ready() -> void:
	# Esconder template inicialmente
	if _option_button_template:
		_option_button_template.hide()
		$AnimatedSprite2D.play("default")
	_initialize_dialog()

func _initialize_dialog() -> void:
	if _id >= data.size():
		queue_free()
		return

	var current_data = data[_id]
	
	# Atualizar elementos visuais
	_name.text = current_data.get("title", "")
	_dialog.text = current_data.get("dialog", "")
	_faceset.texture = load(current_data.get("faceset", ""))
	
	
	# Mostrar opções se existirem
	if current_data.has("options"):
		_show_options(current_data["options"])
	else:
		is_waiting_choice = false

func _show_options(options: Array) -> void:
	is_waiting_choice = true
	_clear_options()
	 
	for option in options:
		if _option_button_template:
			var new_button = _option_button_template.duplicate()
			new_button.text = option["text"]
			new_button.pressed.connect(_on_option_pressed.bind(option["result"]))
			new_button.show()
			_options_container.add_child(new_button)
			await get_tree().process_frame
			$AnimatedSprite2D.position = Vector2(321.667, 63.667)
			$AnimatedSprite2D.play("new_animation")
			new_button.grab_focus()

func _on_option_pressed(result) -> void:
	option_selected.emit(result)
	_clear_options()
	is_waiting_choice = false
	_id += 1
	if _id < data.size():
		_initialize_dialog()
	else:
		queue_free()

func _clear_options() -> void:
	for child in _options_container.get_children():
		if child != _option_button_template:
			child.queue_free()

func _process(delta: float) -> void:
	if is_waiting_choice:
		return

	if Input.is_action_just_pressed("interact"):
		if _dialog.visible_ratio < 1:
			_dialog.visible_characters = -1 
		else:
			_id += 1
			if _id >= data.size():
				queue_free()
			else:
				_initialize_dialog()
