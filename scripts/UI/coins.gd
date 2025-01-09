extends CanvasLayer


func _ready():
	$Control/AnimatedSprite2D.play("default")
func _process(delta):
	$Control/Label.text = str(PlayerManager.coins)

		
		
