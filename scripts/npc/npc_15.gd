extends StaticBody2D

@export var _HUD: CanvasLayer = null
@export var _HUDTitler: CanvasLayer = null  # <<<<< conecte no editor!

const DIALOG_SCREEN = preload("res://scenes/UI/decision_dialog_screen.tscn")
const MISSIONTITLER = preload("res://scenes/UI/missiontitler.tscn")

var action := false
var mission_titler_instance: Node = null
var _titler_mission := {}

# ==================== DIÁLOGOS ====================
# 1 - Diálogo inicial (aceitar/recusar missão)
var _dialog_data1 := {
	0: {"faceset": "Valtteri", "title": "Valtteri", "dialog": "Faz só algumas horas... e já parece uma eternidade."},
	1: {"faceset": "Alfie", "title": "Alfie", "dialog": "Não dormi desde o ataque. Cada vez que fecho os olhos, vejo James sendo levado."},
	2: {"faceset": "Valtteri", "title": "Valtteri", "dialog": "Tentamos seguir os orcs, mas nossas forças acabaram. Estamos perdidos."},
	3: {"faceset": "Alfie", "title": "Alfie", "dialog": "Eles eram muitos. Não temos chance de alcançá-los."},
	4: {"faceset": "Valtteri", "title": "Valtteri", "dialog": "Mas deixá-lo lá... não posso aceitar isso."},
	5: {"faceset": "Alfie", "title": "Alfie", "dialog": "Você... aventureira. Consegue lutar, não é?"},
	6: {"faceset": "Valtteri", "title": "Valtteri", "dialog": "Por favor... vá atrás dele. James precisa de você."},
	7: {"faceset": "Alfie", "title": "Alfie", "dialog": "Não sabemos pra onde foram. Mas se alguém pode salvá-lo... é você."},
	8: {"faceset": "Valtteri", "title": "Valtteri", "dialog": "Não temos forças, não temos direção... só podemos pedir ajuda."},
	9: {
		"faceset": "Alfie",
		"title": "Alfie",
		"dialog": "Por favor. Vá atrás dele. Traga James de volta.",
		"options": [
			{"text": "Eu vou resgatá-lo", "result": "accept"},
			{"text": "Estou ocupada", "result": "decline"}
		]
	}
}

# 2 - Diálogo de entrega da recompensa (primeira vez após completar)
var _dialog_data2 := {
	0: {
		"faceset": "res://assets/ui/2 Portraits with back/icon_42.png",
		"title": "James",
		"dialog": "Você realmente veio me salvar... Eu sabia que alguém viria! Obrigado de coração!",
	},
	1: {
		"faceset": "Valtteri",
		"title": "Valtteri",
		"dialog": "Você conseguiu! James está vivo! Somos eternamente gratos.",
	},
	2: {
		"faceset": "Alfie",
		"title": "Alfie",
		"dialog": "Aqui, pegue isso como prova da nossa gratidão.",
	}
}

# 3 - Diálogo genérico depois que tudo já foi entregue (fala repetida)
var _dialog_data3 := {
	0: {
		"faceset": "Valtteri",
		"title": "Valtteri",
		"dialog": "Obrigado mais uma vez, aventureira. James está a salvo por sua causa."
	},
	1: {
		"faceset": "Alfie",
		"title": "Alfie",
		"dialog": "Nunca vamos esquecer o que você fez por nós. Boa sorte nas suas próximas aventuras!"
	}
}

# ==================== GODOT CALLBACKS ====================
func _ready() -> void:
	$Node2D.visible = false

func _process(_delta: float) -> void:
	if MissionManager.mission4accept and not MissionManager.mission4rewardGiven:
		update_mission_title()
	
	if action and Input.is_action_just_pressed("interact"):
		$Node2D.visible = false
		show_dialog()

# ==================== FUNÇÕES AUXILIARES ====================
func remove_mission_title() -> void:
	if mission_titler_instance:
		mission_titler_instance.queue_free()
		mission_titler_instance = null

func update_mission_title() -> void:
	remove_mission_title()
	if PlayerManager.is_die or MissionManager.mission4rewardGiven:
		return
	
	if MissionManager.mission4complet:
		_titler_mission = {0: {"titler": "Missão concluída! Volte e fale com Valtteri e Alfie."}}
	else:
		_titler_mission = {0: {"titler": "Resgate James - Derrote os Orcs"}}
	
	mission_titler_instance = MISSIONTITLER.instantiate()
	mission_titler_instance.data_titler = _titler_mission
	_HUDTitler.add_child(mission_titler_instance)

func show_dialog() -> void:
	# Limpa diálogos antigos
	for child in _HUD.get_children():
		if child is DecisionDialogScreen:
			child.queue_free()
	
	var new_dialog = DIALOG_SCREEN.instantiate() as DecisionDialogScreen
	
	# 1 - Missão ainda não completada → diálogo inicial
	if not MissionManager.mission4complet:
		new_dialog.data = _dialog_data1
	
	# 2 - Missão completada + recompensa ainda não dada → entrega as moedas
	elif not MissionManager.mission4rewardGiven:
		new_dialog.data = _dialog_data2
		remove_mission_title()                    # título some aqui
		PlayerManager.coins += 80
		MissionManager.mission4rewardGiven = true
	
	# 3 - Tudo já entregue → diálogo genérico de agradecimento
	else:
		new_dialog.data = _dialog_data3
		remove_mission_title()  # garante que não volte a aparecer
	
	new_dialog.option_selected.connect(_on_option_selected)
	_HUD.add_child(new_dialog)
	action = false

func _on_option_selected(result: String) -> void:
	if result == "accept":
		MissionManager.mission4accept = true
		MissionManager.orccount = 0

# ==================== COLISÃO ====================
func _on_area_2d_body_entered(body):
	if body is Player:
		$Node2D.visible = true
		$Node2D/AnimatedSprite2D.play("default")
		action = true

func _on_area_2d_body_exited(body):
	if body is Player:
		$Node2D.visible = false
		action = false
