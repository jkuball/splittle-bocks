extends Node2D


const FILE_BEGIN = "res://scenes/levels/level"
const FILE_TYPE = ".tscn"

func _on_area_2d_body_entered(body):
	# if player is body, then send "goal reached"
	#if body.is_in_group("Player"):
	if body.name == "Player":
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		#print_debug(next_level_number)

		var next_level_path = FILE_BEGIN+str(next_level_number)+FILE_TYPE
		#print_debug(next_level_path)
		get_tree().change_scene_to_file(next_level_path)
