extends Node2D

@onready var sprite: Sprite2D = $"BocksSprite"

var builtToScale = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.modulate = Color.DARK_GREEN
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	builtToScale = false
	sprite.modulate = Color.DARK_RED


func _on_area_2d_body_exited(body: Node2D) -> void:
	builtToScale = true
	sprite.modulate = Color.DARK_GREEN
