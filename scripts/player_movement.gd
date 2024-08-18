extends CharacterBody2D

@export var spawn_target: Node2D
@export var bocksScale = 1.0
@export var number_of_available_boxes = 0
@export var BASE_SPEED = 58000.0

const TEXTURE_PIXEL_SIZE = 16

const Bocks: PackedScene = preload("res://scenes/bocks.tscn")
const Bocks_Preview: PackedScene = preload("res://scenes/bocks_preview.tscn")

signal splittle(scale: Vector2)

signal end(toggle: bool)

signal bocks_count_change(bockses: int)

const minBocksScale = 0.0625

var look_right = true

var is_scale_bocks = false
var bocks_preview

var dead = false

func _ready() -> void:
	bocks_count_change.emit(number_of_available_boxes)


func grow():
	bocksScale *= 2
	apply_scale(Vector2(2, 2))
	splittle.emit(Vector2(.5, .5))


func shrink():
	bocksScale /= 2
	apply_scale(Vector2(.5, .5))
	splittle.emit(Vector2(2, 2))


func _picked_up():
	number_of_available_boxes += 1
	bocks_count_change.emit(number_of_available_boxes)
	grow()


func _a_bocks_decayed(box: Node2D):
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
	assert(number_of_available_boxes > 0)
	number_of_available_boxes -= 1
	bocks_count_change.emit(number_of_available_boxes)
	var bocks = Bocks.instantiate()
	bocks.decayed.connect(_a_bocks_decayed)
	spawn_target.add_child(bocks)
	bocks_list.append(bocks)
	check_decay()
	return bocks


func reposition_preview():
	if look_right:
		bocks_preview.set_position(Vector2(TEXTURE_PIXEL_SIZE*8,0))
	else:
		bocks_preview.set_position(-Vector2(TEXTURE_PIXEL_SIZE*8,0))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("respawn"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var same_level_number = current_scene_file.to_int()
		var same_level_path = "res://scenes/levels/level"+str(same_level_number)+".tscn"
		get_tree().change_scene_to_file(same_level_path)
	
	if dead:
		return
	
	# Add the gravity.
	if (not is_on_floor()) and (not is_scale_bocks):
		velocity += get_gravity() * delta

	if(is_instance_valid(bocks_preview)):
		#$AnimatedSprite2D
		reposition_preview()

	# Handle box preview
	if number_of_available_boxes > 0 and bocksScale > minBocksScale and Input.is_action_just_pressed("player_splittle"):
		bocks_preview = Bocks_Preview.instantiate()
		reposition_preview()
		self.add_child(bocks_preview)

	# Handle box spawning.
	if number_of_available_boxes > 0 and Input.is_action_just_released("player_splittle"):
		if is_instance_valid(bocks_preview):
			bocks_preview.queue_free()
			if bocksScale > minBocksScale and bocks_preview.builtToScale:
				var bocks = make_bocks()

				## Prototype bocks scaling ##
				bocks.find_child("Collider").apply_scale(Vector2(bocksScale,bocksScale))

				var scale_factor = TEXTURE_PIXEL_SIZE * scale.x

				if look_right:
					bocks.set_position(get_position() + Vector2(TEXTURE_PIXEL_SIZE * 8 * bocksScale, 0))
				else:
					bocks.set_position(get_position() + Vector2(-TEXTURE_PIXEL_SIZE * 8 * bocksScale, 0))

				shrink()



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		if is_scale_bocks:
			if look_right:
				velocity.y = -direction * BASE_SPEED * bocksScale * delta
			else:
				velocity.y = direction * BASE_SPEED * bocksScale * delta
		else:
			look_right = direction > 0
			velocity.x = direction * BASE_SPEED * bocksScale * delta
			if velocity.y<0:
				velocity.y = 0
		if is_on_floor():
			look_right = direction > 0
			velocity.x = direction * BASE_SPEED * bocksScale * delta
	else:
		if is_scale_bocks:
			velocity.y = move_toward(velocity.y, 0, BASE_SPEED * bocksScale * delta)
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED * bocksScale * delta)

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


func _on_platz_area_body_entered(body: Node2D):
	if body is TileMapLayer:
		die()

func die():
	$CPUParticles2D.emitting = true
	#print_debug("boom -- ich bin geplatzt! ", body)
	$AnimatedSprite2D.visible = false
	end.emit(true)
	dead = true
