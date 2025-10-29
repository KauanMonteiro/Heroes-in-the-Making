extends Node


static var instance: EffectManager

func _init():
	instance = self

func potionheal1():
	PlayerManager.life += 1
	print(PlayerManager.life_bonus)

func potionspeed1():
	pass

func executar_efeito(efeito_nome: String):
	if has_method(efeito_nome):
		call(efeito_nome)
	else:
		push_error("Efeito não encontrado: " + efeito_nome)
