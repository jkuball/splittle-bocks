extends Camera2D

@export var follow_target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#
func _physics_process(delta):
	# lerp dat shit
	transform.origin = lerp(transform.origin, follow_target.transform.origin, 0.2)
