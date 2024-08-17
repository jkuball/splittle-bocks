extends Camera2D

@export var player: Node2D

var wanted_zoom: Vector2

func _ready():
	wanted_zoom = zoom

func _physics_process(delta):
	# TODO: only move the camera if the player gets to the borders
	
	# lerp dat shit
	transform.origin = lerp(transform.origin, player.transform.origin, 0.2)
	zoom = lerp(zoom, wanted_zoom, 0.2)
 
func _on_player_splittle(scale):
	if zoom == wanted_zoom:
		wanted_zoom = zoom * scale
	else:
		wanted_zoom = wanted_zoom * scale
