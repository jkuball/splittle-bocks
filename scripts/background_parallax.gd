extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_blocks_scale_change(change: Vector2) -> void:
	pass
	#print_debug(change)
	#print_debug(Vector2(change.x,change.y))
	#apply_scale(Vector2(change.x,change.y))
