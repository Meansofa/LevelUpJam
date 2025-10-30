extends Button

@onready var gameplay : Node2D = $"../../../.."
@onready var card_detector :Area2D = $card_detector
@export_range(0, 3) var slot_number : int #what slot_number is this button starts at 0 index

func _ready() -> void:
	%EndTurn.connect("pressed", _who_pressed_end_turn)

#while select_card is in the card_detector area and select_card stops dragging
func place_card(card : piece):
	gameplay.place_piece(slot_number, card.name) #place the card
	#rpc doesn't allow object passed from a function so we have to send raw data like String and not Object
	
	stop_detection()

#When either player or opponent pressed end_turn
func _who_pressed_end_turn():
	var player_id = multiplayer.get_unique_id()
	
	enable_detection(player_id)
	rpc("enable_detection", player_id)

func stop_detection():
	card_detector.monitorable = false
	card_detector.visible = false
	self.button_mask = false

@rpc("any_peer")
func enable_detection(player_id):
	print("card_detector: ", card_detector, " : player_id: ", player_id)
	card_detector.monitorable = true
	card_detector.visible = true
	self.button_mask = MOUSE_BUTTON_MASK_LEFT

func _on_pressed() -> void:
	%Warning.play("DragACard")
