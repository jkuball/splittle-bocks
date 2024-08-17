extends CharacterBody2D

@export var spawn_target: Node2D

const Bocks: PackedScene = preload("res://scenes/bocks.tscn")

signal splittle(scale: Vector2)

const SPEED = 58000.0

var bocksScale = 1.0
const minBocksScale = 0.0625

var look_right = true

var is_scale_bocks = false

func _a_bocks_decayed():
	print_debug("TODO: A bocks decayed, I should grow!")

var bocks_list: Array[Node2D] = []
func make_bocks() -> Node2D:
	var bocks = Bocks.instantiate()
	bocks.decayed.connect(_a_bocks_decayed)
	spawn_target.add_child(bocks)
	
	bocks_list = bocks_list.filter(is_instance_valid) # remove freed boxes
	for bock in bocks_list:
		# mark them as "not the newest" box
		bock.begin_decay()

	bocks_list.append(bocks)
	return bocks

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if (not is_on_floor()) and (not is_scale_bocks):
		velocity += get_gravity() * delta

	# Handle box spawning.
	if bocksScale > minBocksScale and Input.is_action_just_pressed("player_splittle"):
		var bocks = make_bocks()

		## Prototype bocks scaling ##
		bocks.find_child("Collider").apply_scale(Vector2(bocksScale,bocksScale))

		bocksScale = bocksScale / 2
		print_debug(bocksScale)

		var scale_factor = get_child(0).texture.get_size().x * scale.x

		if look_right:
			bocks.set_global_position(get_global_position() + Vector2(scale_factor, 0))
		else:
			bocks.set_global_position(get_global_position() + Vector2(-scale_factor, 0))

		## /Prototype bocks scaling/ ##

		apply_scale(Vector2(0.5,0.5))
		splittle.emit(Vector2(2, 2))


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		if is_scale_bocks:
			if look_right:
				velocity.y = -direction * SPEED * bocksScale * delta
			else:
				velocity.y = direction * SPEED * bocksScale * delta
		else:
			look_right = direction > 0
			velocity.x = direction * SPEED * bocksScale * delta
		if is_on_floor():
			look_right = direction > 0
			velocity.x = direction * SPEED * bocksScale * delta
	else:
		if is_scale_bocks:
			velocity.y = move_toward(velocity.y, 0, SPEED * bocksScale * delta)
		velocity.x = move_toward(velocity.x, 0, SPEED * bocksScale * delta)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bocks"):
		if not is_scale_bocks:
			is_scale_bocks = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Bocks"):
		if is_scale_bocks:
			is_scale_bocks = false
	pass # Replace with function body.
