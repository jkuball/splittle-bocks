extends Node2D

var decaying: bool = false

signal decayed

func begin_decay():
	if not decaying:
		print_debug(self, ": I am dying :(")
		
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($"RigidBody/Collider/Sprite", "modulate", Color.DARK_RED, 2)
		tween.tween_property(self, "scale", Vector2.ZERO, 2)
		
		# If you use set_parallel, the callback will be called instantly.
		# In that case, we need to use the 'finished' signal.
		#tween.tween_callback(queue_free)
		tween.finished.connect(queue_free)
		tween.finished.connect(decayed.emit)
		
		decaying = true
