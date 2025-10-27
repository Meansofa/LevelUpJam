@tool
extends Control

@onready var elixers_parent = $PanelContainer/Elixers
@onready var animation_player : AnimationPlayer = $PanelContainer/AnimationPlayer

@export var elixer_texture : CompressedTexture2D
@export var start_elixer_count := 3
@export var max_elixer := 10
@export var end_turn_elixer_count := 2 #how much elixer is generated after pressing end turn

func _ready() -> void:
	%EndTurn.connect("pressed", end_turn_elixer) #after pressing end turn generate elixer
	starting_elixer()

func starting_elixer():
	if elixers_parent.get_child_count() >= start_elixer_count:
		return
	create_new_elixer(start_elixer_count)

func end_turn_elixer():
	create_new_elixer(start_elixer_count)

#called by gameplay.gd after pressing end turn
func create_new_elixer(elixer_count : int):
	for count in range(elixer_count - 1):
		if elixers_parent.get_child_count() >= max_elixer:
			#print("elixers_parent.get_child_count(): ", elixers_parent.get_child_count())
			return
		#print(name, ": create_new_elixer")
		var textureRect = TextureRect.new()
		textureRect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
		textureRect.texture = elixer_texture
		
		elixers_parent.add_child(textureRect)

#called in pick_card.gd after trying to put a card to a slot, 
func enough_elixer(elixer_cost : int) -> bool:
	if elixers_parent.get_child_count() >= elixer_cost: #if elixer count has more than or equal to the elixer cost of the pawn
		for elixer in range(elixer_cost):
			elixers_parent.remove_child(elixers_parent.get_children()[randi_range(0, elixers_parent.get_child_count() - 1)]) #remove 1 a random elixer child
		return true 
	
	#Not enough elixer
	animation_player.play("not_enough_elixer")
	return false
