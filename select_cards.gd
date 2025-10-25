extends Area2D

var dragging := false #if the card is getting dragged
var in_area := false #if mouse is hovering in the card
var draggable := true #if the card can be dragged

signal is_dragging

@onready var spawn_position = self.position
var in_slot : bool #if the card is released on top of a slot
var slots := [] #area2d of the slot
var nearest_slot : Area2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and draggable:
			if event.pressed and in_area: #if player's mouse is in the collision of this area and player is holding left click 
				dragging = true
				emit_signal("is_dragging", true)
			else: #if player released the left click
				_release_card()

	if event is InputEventMouseMotion:
		if not slots.is_empty():
			for slot in slots:
				if nearest_slot == null:
					nearest_slot = slot
				if global_position.distance_to(slot.global_position) < global_position.distance_to(nearest_slot.global_position):
					nearest_slot = slot

#check where to put the card after releasing
func _release_card():
	dragging = false
	emit_signal("is_dragging", false)
	scale.x = 1
	scale.y = 1
	z_index = 0

	if in_slot == false:  #if the card was released and is not near a slot return to hand
		position = spawn_position
	else:
		self.global_position = nearest_slot.global_position
		disable_monitoring()

func disable_monitoring():
	in_area = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_deferred("input_pickable", false)
	draggable = false

func _process(_delta):
	#print("dragging: ", dragging)
	if dragging:
		scale.x = 1.1
		scale.y = 1.1
		z_index = 100
		global_position = get_global_mouse_position()

func _on_mouse_entered() -> void:
	in_area = true

func _on_mouse_exited() -> void:
	in_area = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Slot"):
		slots.append(area)
		in_slot = true
		var i = 1
		for slot in slots:
			print("slot, ", i, ": ", slot)
			i += 1

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Slot"):
		slots.erase(area)
		in_slot = false
