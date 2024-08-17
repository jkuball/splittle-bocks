extends CharacterBody2D

@export var spawn_target: Node2D

const Bocks: PackedScene = preload("res://scenes/bocks.tscn")
const Bocks_Preview: PackedScene = preload("res://scenes/bocks_preview.tscn")

signal splittle(scale: Vector2)

const SPEED = 58000.0

var bocksScale = 1.0
const minBocksScale = 0.0625

var look_right = true

var is_scale_bocks = false
var bocks_preview

func _a_bocks_decayed(box: Node2D):
	bocksScale *= 2
	apply_scale(Vector2(2, 2))
	splittle.emit(Vector2(.5, .5))
	
	bocks_list.erase(box)
	check_decay()
	for bocks in bocks_list:
		var rb: RigidBody2D = bocks.get_node("RigidBody")
		rb.sleeping = false

func check_decay():
	bocks_list = bocks_list.filter(is_instance_valid) # remove freed boxes
	if len(bocks_list) > 0 and bocks_list.all(func(box): return not box.decaying):
		bocks_list[0].begin_decay()

var bocks_list: Array[Node2D] = []
func make_bocks() -> Node2D:
	var bocks = Bocks.instantiate()
	bocks.decayed.connect(_a_bocks_decayed)
	spawn_target.add_child(bocks)
	bocks_list.append(bocks)
	check_decay()
	return bocks

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if (not is_on_floor()) and (not is_scale_bocks):
		velocity += get_gravity() * delta

	if(is_instance_valid(bocks_preview)):
		if look_right:
			bocks_preview.set_position(Vector2($"Sprite2D".texture.get_size().x*8,0))
		else:
			bocks_preview.set_position(Vector2(-$"Sprite2D".texture.get_size().x*8,0))

	# Handle box preview
	if bocksScale > minBocksScale and Input.is_action_just_pressed("player_splittle"):
		bocks_preview = Bocks_Preview.instantiate()
		self.add_child(bocks_preview)
		#print_debug(Vector2($"Sprite2D".texture.get_size().x*scale.x*8,0))


	# Handle box spawning.
	if Input.is_action_just_released("player_splittle"):
		if is_instance_valid(bocks_preview):
			bocks_preview.queue_free()
			if bocksScale > minBocksScale and bocks_preview.builtToScale:
				var bocks = make_bocks()

				## Prototype bocks scaling ##
				bocks.find_child("Collider").apply_scale(Vector2(bocksScale,bocksScale))

				bocksScale = bocksScale / 2
				#print_debug(bocksScale)

				var scale_factor = get_child(0).texture.get_size().x * scale.x

				if look_right:
					bocks.set_global_position(get_global_position() + Vector2($"Sprite2D".texture.get_size().x*scale.x*8,0))
				else:
					bocks.set_global_position(get_global_position() + Vector2(-$"Sprite2D".texture.get_size().x*scale.x*8,0))

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
