extends Area2D

@onready var spawn_position = self.position

@export var elixer_texture : CompressedTexture2D

var dragging := false #if the card is getting dragged
var in_area := false #if mouse is hovering in the card
var draggable := false #if the card can be dragged

var in_slot : bool #if the card is released on top of a slot
var slots := [] #area2d of the slot
var nearest_slot : Area2D

@export var cards: Array[piece]
var card : piece

func _ready() -> void:
	start()
	
	card = cards[randi_range(0, cards.size() - 1)]
	update_visual()

func start():
	%AnimationPlayer.play("return")
	await %AnimationPlayer.animation_finished
	draggable = true

func update_visual():
	%health_label.text = "[b]" + str(card.health)
	%card_label.text = "[center]" + card.name
	%damage_label.text = "[b]" + str(card.damage)
	$%pawn_texture.texture_normal = card.pawn_texture
	for elixer in range(card.elixer):
		var textureRect = TextureRect.new()
		textureRect.texture = elixer_texture
		%elixer.add_child(textureRect)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and draggable:
			if event.pressed and in_area: #if player's mouse is in the collision of this area and player is holding left click 
				dragging = true
			else: #if player released the left click
				if dragging == true:
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
	
	scale.x = 1
	scale.y = 1
	z_index = 0
	
	if in_slot == false or %Elixer.enough_elixer(card.elixer) == false: #if the card was released and is not near a slot return to hand
		print("in_slot ==", in_slot)
		position = spawn_position
	else: #Place the card in the slot ------------------------------------------
		place_card()

func place_card():
	if nearest_slot == null:
		return
	nearest_slot.get_parent().place_card(card) #call the function inside the slot script
	print("card place at: ", nearest_slot.get_parent().name)
	self.global_position = nearest_slot.global_position
	disable_monitoring()
	
	%AnimationPlayer.play("dissolve")
	await %AnimationPlayer.animation_finished
	
	position = spawn_position
	
	%AnimationPlayer.play("return")
	await %AnimationPlayer.animation_finished
	enable_monitoring()

func disable_monitoring():
	in_area = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_deferred("input_pickable", false)
	draggable = false

func enable_monitoring():
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	set_deferred("input_pickable", true)
	draggable = true

func play_dissolve() -> bool:
	%AnimationPlayer.play("dissolve")
	await %AnimationPlayer.animation_finished
	return true

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

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Slot"):
		slots.erase(area)
		if slots.size() <= 0:
			in_slot = false
