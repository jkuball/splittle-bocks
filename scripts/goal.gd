extends Node2D

signal goal_reached

func _on_area_2d_body_entered(body):
	# if player is body, then send "goal reached"
	if body.name == "Player":
		goal_reached.emit()
