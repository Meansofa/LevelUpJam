extends Button

@onready var card_parent : Marker2D = $card
@export_range(0, 3) var slot : int #what slot is this button starts at 0 index

var card : Area2D #the card on it's slot

func _on_card_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Card"):
		card = area #set the area node as the card 
		card.connect("is_dragging", _place_card) #connect to the dragging signal of the card to emit when dragging is changed

func _on_card_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("Card"):
		if card == area:
			_disconnect_card() #since card is not in the collision anymore

func _place_card(is_dragging : bool):
	if is_dragging == false:
		card.position = card_parent.global_position
		%GamePlay.place_piece(slot, card) #place the card
		_disconnect_card() #since the card has already been placed in the slot

func _disconnect_card():
	card.disconnect("is_dragging", _place_card) #disconnect the signal dragging from the card
	card = null #erase the card
