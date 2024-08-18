extends Node2D

@export var starting_scale = 1.0


func _ready():
	set_pickup_scale(Vector2(starting_scale, starting_scale))


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		queue_free()
		body._picked_up()


func set_pickup_scale(scale: Vector2):
	print_debug("i am scaling this pickup to ", scale)
	$CollisionShape2D.scale = scale
	$"Area2D/CollisionShape2D".scale = scale
