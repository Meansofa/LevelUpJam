extends TextureRect

var curr_crown := 0
@export var crown_amount_label : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_crown_amount(curr_crown)

func change_crown_amount(value : int):
	crown_amount_label.text = "[b]" + str(value)

func add_crown():
	%AnimationPlayer.play("add_crown")
	curr_crown += 1
	change_crown_amount(curr_crown)
