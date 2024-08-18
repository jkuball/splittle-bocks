extends Node2D

const Pickup: PackedScene = preload("res://scenes/pickup.tscn")

var decaying: bool = false

const decay_seconds = 2

signal decayed(bocks: Node2D)

func spawn_pickup():
	var pickup = Pickup.instantiate()
	pickup.transform.origin = transform.origin + Vector2.UP * scale.y
	pickup.set_pickup_scale($RigidBody/Collider.scale)
	get_parent().add_child(pickup)

func begin_decay():
	if not decaying:
		#print_debug(self, ": I am dying :(")

		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($"RigidBody/Collider/Sprite", "modulate", Color.DARK_RED, decay_seconds)
		#tween.tween_property(self, "scale", Vector2.ZERO, decay_seconds)
		#tween.tween_property(self, "transform", transform, decay_seconds)

		# If you use set_parallel, the callback will be called instantly.
		# In that case, we need to use the 'finished' signal.
		#tween.tween_callback(queue_free)
		tween.finished.connect(queue_free)
		tween.finished.connect(func lambda(): decayed.emit(self))
		tween.finished.connect(spawn_pickup)

		decaying = true
