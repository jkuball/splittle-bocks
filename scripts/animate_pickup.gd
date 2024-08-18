extends Sprite2D

@onready var orig_scale = scale

func _ready():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()

	tween.tween_property(self, "scale", orig_scale * 1.1, 0.5)
	tween.tween_property(self, "scale", orig_scale * 0.9, 0.5)

func _process(delta):
	var rot_speed = rad_to_deg(0.01)  # 30 deg/sec
	rotation = (rotation + rot_speed * delta)
