extends Control

@onready var elixers_parent = $PanelContainer/Elixers

@export var elixer_texture : CompressedTexture2D
@export var max_elixer := 5

func _ready() -> void:
	%EndTurn.connect("pressed", create_new_elixer) #after pressing end turn create a new elixer

#called by gameplay.gd after pressing end turn
func create_new_elixer():
	if elixers_parent.get_child_count() >= max_elixer:
		return
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
	return false
