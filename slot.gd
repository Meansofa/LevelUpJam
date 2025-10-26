extends Button

@onready var card_detector :Area2D = $card_detector
@export_range(0, 3) var slot_number : int #what slot_number is this button starts at 0 index

var select_card : Area2D #the card on it's slot_number
var card : piece

func _ready() -> void:
	%EndTurn.connect("pressed", enable_detection)

func _on_card_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Card"):
		select_card = area #set the area node as the select_card 
		card = select_card.card
		select_card.connect("place_card", _place_card) #connect to the dragging signal of the select_card to emit when dragging is changed

func _on_card_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("Card"):
		if select_card == area:
			_disconnect_card() #since select_card is not in the collision anymore

#while select_card is in the card_detector area and select_card stops dragging
func _place_card():
	%GamePlay.place_piece(slot_number, card) #place the card
	stop_detection()

func stop_detection():
	_disconnect_card() #since the select_card has already been placed in the slot_number
	card_detector.set_deferred("monitorable", false)
	card_detector.set_deferred("monitoring", false)
	card_detector.visible = false

func enable_detection():
	card_detector.set_deferred("monitorable", true)
	card_detector.set_deferred("monitoring", true)
	card_detector.visible = true

func _disconnect_card():
	select_card.disconnect("place_card", _place_card) #disconnect the signal dragging from the card
	select_card = null #erase the card
