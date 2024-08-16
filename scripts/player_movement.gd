extends CharacterBody2D

@export var spawn_target: Node2D

const Bocks: PackedScene = preload("res://scenes/bocks.tscn")

signal splittle(scale)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bocksScale = 1.0
var spawn_right = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_splittle"):
		var bocks = Bocks.instantiate()
		spawn_target.add_child(bocks)
		
		## Prototype bocks scaling ##
		bocks.get_child(0).apply_scale(Vector2(bocksScale,bocksScale))
		bocksScale = bocksScale/2
		print_debug(get_child(0).texture.get_size().x*scale.x)
		if spawn_right:
			bocks.set_global_position(get_global_position()+Vector2(get_child(0).texture.get_size().x*scale.x,0))
		else:
			bocks.set_global_position(get_global_position()+Vector2(-get_child(0).texture.get_size().x*scale.x,0))
		## /Prototype bocks scaling/ ##
		
		apply_scale(Vector2(0.5,0.5))
		splittle.emit(Vector2(2, 2))
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		if direction>0:
			spawn_right = true
		else:
			spawn_right = false	
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
