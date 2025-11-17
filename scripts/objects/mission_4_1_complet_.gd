extends Area2D



func _on_body_entered(body):
	if body is Npc16:
		MissionManager.mission4_1complet = true
