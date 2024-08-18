extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x:Signal=$Player.bocks_count_change
	x.connect($HUD._on_bocks_count_change)
	$Player._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
