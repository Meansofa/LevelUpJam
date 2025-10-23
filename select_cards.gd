extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("TextureButton").connect("toggled", _is_toggled)

func _is_toggled(real : bool):
	print( name, ": ", "real: ", real)
	if real:
		scale.x = 1.1
		scale.y = 1.1
	else:
		scale.x = 1
		scale.y = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
