extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_end(toggle: bool) -> void:
	#print_debug("Das Ende naht!")
	$Label_Die.visible = toggle

func _on_bocks_count_change(bockses: int) -> void:
	#print_debug("Das Ende naht!")
	$HBoxContainer/bocks_count.visible = bockses != 0
	$HBoxContainer/TextureRect.visible = bockses != 0
	$HBoxContainer/bocks_count.text = str(bockses)
