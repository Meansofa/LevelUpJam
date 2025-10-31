extends PanelContainer

func new_round():
	reroll_cards()
func reroll_cards():
	for button in $VBoxContainer/Options.get_children():
		button.get_random_card()
	for button in $VBoxContainer/Options2.get_children():
		button.get_random_card()
	for button in $VBoxContainer/Options3.get_children():
		button.get_random_card()
