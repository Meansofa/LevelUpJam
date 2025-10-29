extends Control

var player_chose := ""
var opponent_chose  := ""

func get_pressed_button(chosen : String):
	var player_id = multiplayer.get_unique_id()
	rock_paper_scissors(player_id, chosen)
	rpc("rock_paper_scissors", player_id, chosen)
	
@rpc("any_peer")
func rock_paper_scissors(player_id, chosen : String):
	if player_id == multiplayer.get_unique_id():
		player_chose = chosen
		chosen = ""
	else:
		opponent_chose = chosen
		chosen = ""
	if player_chose != "" and opponent_chose != "":
		if player_chose == "paper":
			if opponent_chose == "rock":
				get_parent().who_goes_first(player_id)
		elif player_chose == "rock":
			if opponent_chose == "scissors":
				get_parent().who_goes_first(player_id)
		elif player_chose == "scissors":
			if opponent_chose == "paper":
				get_parent().who_goes_first(player_id)
		self.queue_free()



func _on_rock_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_pressed_button("rock")

func _on_paper_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_pressed_button("paper")

func _on_scissors_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_pressed_button("scissors")
