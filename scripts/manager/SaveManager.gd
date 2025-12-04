extends Node

const SAVE_PATH := "user://savegame.save"

# Lista todos os managers que queremos salvar
var managers_to_save = [
	MissionManager,
	PlayerManager,
	GameManager
]

func save_game(current_scene_path: String, player_position: Vector2):
	var save_file = ConfigFile.new()

	save_file.set_value("game", "current_scene", current_scene_path)
	save_file.set_value("game", "player_position_x", player_position.x)
	save_file.set_value("game", "player_position_y", player_position.y)

	# Salva cada manager
	for manager in managers_to_save:
		var section_name = manager.name if manager.name else manager.get_class()
		var data = {}

		# Pega todas as variáveis exportadas ou normais que queremos salvar
		for property in manager.get_property_list():
			var prop_name = property.name
			if prop_name.begins_with("_") or (property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) == 0:
				continue
			var value = manager.get(prop_name)

			# Só salva tipos simples (int, float, bool, String, Vector2, Dictionary, Array)
			if value is int or value is float or value is bool or value is String or \
			   value is Vector2 or value is Dictionary or value is Array:
				data[prop_name] = value

		save_file.set_value("managers", section_name, data)

	# Salva no disco
	var err = save_file.save(SAVE_PATH)
	if err != OK:
		print("Erro ao salvar jogo: ", err)
		return false
	else:
		print("Jogo salvo com sucesso!")
		return true
		

func load_game() -> bool:
	var save_file = ConfigFile.new()
	
	# Tenta carregar o arquivo de save
	if save_file.load(SAVE_PATH) != OK:
		print("Nenhum save encontrado ou erro ao carregar.")
		return false
	
	# Carrega cena atual e posição do jogador
	var current_scene = save_file.get_value("game", "current_scene", "res://world.tscn")
	var pos_x = save_file.get_value("game", "player_position_x", 0)
	var pos_y = save_file.get_value("game", "player_position_y", 0)
	GameManager.last_position = Vector2(pos_x, pos_y)
	
	# Carrega os managers
	for manager in managers_to_save:
		var section_name = manager.name if manager.name else manager.get_class()
		if save_file.has_section_key("managers", section_name):
			var data = save_file.get_value("managers", section_name, {})
			for key in data.keys():
				if manager.has_method("set") or key in manager:
					manager.set(key, data[key])
	
	# Muda para a cena salva
	get_tree().change_scene_to_file(current_scene)
	print("Jogo carregado com sucesso!")
	return true
