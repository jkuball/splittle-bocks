extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x: Signal = $Player.bocks_count_change
	x.connect($HUD._on_bocks_count_change)
	$Player._ready()

	var y: Signal = $Player.end
	y.connect($HUD._on_player_end)

	var z: Signal = $Player.splittle
	z.connect($BackgroundParallax._on_blocks_scale_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
