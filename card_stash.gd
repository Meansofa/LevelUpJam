extends Control

@onready var cards_amount_label : RichTextLabel =%CardsAmount

var cards_amount := 69

func _ready() -> void:
	cards_amount_label.text ="[center][b]" + str(cards_amount)

func count_cards():
	pass

func reduce_cards():
	cards_amount -= 1
	cards_amount_label.text = "[center][b]" + str(cards_amount)
