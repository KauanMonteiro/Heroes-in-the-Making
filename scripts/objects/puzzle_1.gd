extends Node2D


func _on_area_2d_body_entered(body):
	if body is Pushables:
		if body.column_id == 1:
			body.active = true

func _on_area_2d_2_body_entered(body):
	if body is Pushables:
		if body.column_id == 2:
			body.active = true

func _on_area_2d_3_body_entered(body):
	if body is Pushables:
		if body.column_id == 3:
			body.active = true

func _on_area_2d_body_exited(body):
	if body is Pushables:
		if body.column_id == 1:
			body.active = false

func _on_area_2d_2_body_exited(body):
	if body is Pushables:
		if body.column_id == 2:
			body.active = false
				
func _on_area_2d_3_body_exited(body):
	if body is Pushables:
		if body.column_id == 3:
			body.active = false
