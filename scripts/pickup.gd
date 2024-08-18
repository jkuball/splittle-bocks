extends Node2D


@export var initial_scale: float = 1

var scaled: bool = false

func _ready():
	set_pickup_scale(Vector2(initial_scale, initial_scale))


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		queue_free()
		body._picked_up()


func set_pickup_scale(scale: Vector2):
	if scaled:
		return

	print_debug("i am scaling this pickup to ", scale)

	$CollisionShape2D.scale = scale
	scaled = true
