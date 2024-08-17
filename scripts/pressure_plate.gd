extends Node2D

signal pressure_plate(pressed:bool)
@onready var animation: AnimatedSprite2D = $"plate_sprite"

@export var single_activate = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	pressure_plate.emit(true)
	animation.play("On")
	#print_debug("On")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not single_activate:
		pressure_plate.emit(false)
		animation.play("Off")
		#print_debug("Off")
