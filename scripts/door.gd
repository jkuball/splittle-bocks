extends StaticBody2D

func _on_pressure_plate_pressure_plate(pressed: bool) -> void:
	if pressed:
		$AnimatedSprite2D.play("default")
		$CollisionShape2D.disabled = true
		#print_debug($CollisionShape2D.disabled)
	else:
		$AnimatedSprite2D.play_backwards("default")
		$AnimatedSprite2D.animation_finished.connect(func():$CollisionShape2D.disabled = false)
		
