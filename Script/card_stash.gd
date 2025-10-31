extends Control

@onready var cards_amount_label : RichTextLabel = %CardsAmount

@export var starting_cards : Array[piece] #player's starting cards

var card_stash : Array[piece] #The player's whole cards including discards
var player_cards : Array[piece] #current cards that wasnt played or discarded

var cards_amount := 69

func new_round():
	_reroll_player_cards()

func _ready() -> void:
	_reroll_player_cards()

func add_card_to_stash(card : piece):
	card_stash.append(card)
	_reroll_player_cards()

#called after a pick_card places a card in a slot
func request_card(pick_card : Area2D):
	display_card(pick_card) #gives a card to the requester
	print("player_cards.size(): ", player_cards.size())
	#_print_available_cards()

func display_card(pick_card : Area2D):
	pick_card.give_card(_get_random_card_from_stash())
	update_cards_amount_label()

func _get_random_card_from_stash() -> piece:
	if player_cards.is_empty(): #if can't spare anymore cards
		_reroll_player_cards()
	
	print("player_cards.is_empty(): ", player_cards.is_empty())
	var card = player_cards[randi_range(0, player_cards.size() - 1)]
	player_cards.erase(card) #discard the card
	return card

#reroll player's cards
func _reroll_player_cards()-> void: #returns true if cards have been rerolled
	if card_stash.is_empty(): #When card stash is empty possibly because the game just started
		card_stash.assign(starting_cards)
	player_cards.assign(card_stash)
	
	print(name, ": cards rerolled")
	update_cards_amount_label()

func update_cards_amount_label():
	if cards_amount_label == null: #when cards_amount_label didnt load yet and is already called
		return
	if not player_cards.is_empty():
		cards_amount_label.text = "[center][b]" + str(player_cards.size())

func _print_available_cards():
	var player_id = multiplayer.get_unique_id()
	
	var cnt := 1
	for card in player_cards:
		
		print("player_id: ", player_id, ": ", cnt, " : ", card.name)
		cnt += 1
