extends ProgressBar

@onready var health_label = $health_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = 100

func _on_value_changed(new_value) -> void:
	health_label.text = "[b][center]" + str(new_value)
	print("player took damage")

#called from gameplay.gd when a player takes damage
func take_damage(damage : int):
	value -= damage
	
