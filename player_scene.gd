extends Node2D

func _on_health_pressed() -> void:
	#$health_bar.text = str(int($health_bar.text) - 1)
	
	#Get the player id of the player who clicked this button
	#host's player id is always 1
	var player_id = multiplayer.get_unique_id()

	_who_clicked_who(player_id) #This updates your side
	rpc("_who_clicked_who", player_id) #This updates for the other players
	

@rpc("any_peer")
func _who_clicked_who(player_id):
	print("player_id: ", player_id)
	print("multiplayer.get_unique_id(): ",multiplayer.get_unique_id())
	if multiplayer.get_unique_id() == player_id: #if you cliked the button the other player gets damage(Check their screen if their green character has decreased health)
		var enemy_health_bar = get_parent().get_node("OpponentScene/health_bar")
		enemy_health_bar.text = str(int(enemy_health_bar.text) - 1)
	else: #if the player clicked the button meaning you take damage
		$health_bar.text = str(int($health_bar.text) - 1)
		
