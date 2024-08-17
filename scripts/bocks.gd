extends Node2D

@onready var collider: CollisionShape2D = $"RigidBody/Collider"

@export var shrink_speed = 100

const target_scale = Vector2(0.125, 0.125)
const leeway = 0.2

signal scaling(scale: Vector2)
signal die(scale: Vector2)

func _process(delta):
	# continuously shrink (and also shrink the collider so the physics engine doesnt overwrite it)
	scale = scale.lerp(target_scale, delta)
	collider.scale = scale
	die.emit(scale)

	# when I am reaching a specific small point, remove myself from the node tree
	if scale <= (target_scale + Vector2(leeway, leeway)):
		die.emit(scale)
		queue_free()
