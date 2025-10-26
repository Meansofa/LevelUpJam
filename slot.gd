extends Button

@onready var gameplay : Node2D = $"../../../.."
@onready var card_detector :Area2D = $card_detector
@export_range(0, 3) var slot_number : int #what slot_number is this button starts at 0 index

func _ready() -> void:
	%EndTurn.connect("pressed", enable_detection)

#while select_card is in the card_detector area and select_card stops dragging
func place_card(card : piece):
	gameplay.place_piece(slot_number, card.name) #place the card
	#rpc doesn't allow object passed from a function
	
	stop_detection()

func stop_detection():
	card_detector.set_deferred("monitorable", false)
	card_detector.set_deferred("monitoring", false)
	card_detector.visible = false

func enable_detection():
	card_detector.set_deferred("monitorable", true)
	card_detector.set_deferred("monitoring", true)
	card_detector.visible = true
