extends CanvasLayer

var current_mission_titler: Control = null

func add_mission_titler(titler_instance: Control) -> void:
	if current_mission_titler:
		current_mission_titler.queue_free()
	
	current_mission_titler = titler_instance
	add_child(current_mission_titler) 

func clear_mission_titler() -> void:
	if current_mission_titler:
		current_mission_titler.queue_free()
		current_mission_titler = null
