extends Node2D

const rows := 6
const cols := 4

var board : Array = []

var player_cards = []

func restart():
	get_tree().reload_current_scene()

#called from slot.gd >>>>>>>>>>>>>>>>>>>>>>>>>>>>
func place_piece(slot_number : int, card_name : String):
	var player_id = multiplayer.get_unique_id()
	
	who_placed_piece(slot_number, card_name, player_id)
	rpc("who_placed_piece", slot_number, card_name, player_id) #This updates for the other players

#rpc doesn't allow object passed from a function
func get_card_with_name(card_name : String) -> piece:
	for card in %AllCards.cards:
		if card_name == card.name:
			return card.duplicate()
	var error = piece.new()
	error.name = "ERROR CARD"
	return error

@rpc("any_peer")
func who_placed_piece(slot_number : int, card_name : String, player_id):
	#print(player_id, ": placed a piece")
	var card = get_card_with_name(card_name) #rpc doesn't allow object passed from a function
	
	if multiplayer.get_unique_id() == player_id: #If you are the player on this networkd
		card.team = piece.teams.player #assign piece to player
		board[rows - 1][slot_number] = card
	else: #If the player id was the opponent
		card.team = piece.teams.opponent #assign piece to opponent
		board[0][slot_number] = card
	
	update_simulation()
	view_board()
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

func calculate_index(x:int, y:int) -> int:
	return (x*cols) + y

func attack():
	for x in range(rows):
		for y in range(cols):
			var pawn = board[x][y]
			if pawn is piece:
				var square : Area2D = %Board.get_node("Square" + str(calculate_index(x, y))) #the node in game corresponding to an index in the board
				var front_piece = null #piece in front of the pawn
				var front_square : Area2D #square in front of the pawn
				if pawn.team  == piece.teams.player:
					front_piece = board[x - pawn.attack_direction][y]
					front_square = %Board.get_node("Square" + str(calculate_index(x - pawn.attack_direction, y))) #the node in game corresponding to an index in the board
				elif pawn.team  == piece.teams.opponent:
					front_piece = board[x + pawn.attack_direction][y]
					front_square = %Board.get_node("Square" + str(calculate_index(x + pawn.attack_direction, y))) #the node in game corresponding to an index in the board

				#ATTACK------------------------------------------------------------
				if front_piece is piece:
					if pawn.attack_mode:
						front_piece.health -= pawn.damage
						square.attack_pawn(front_square, front_piece) #IMPORTANT using await, only this function will wait, other functions will keep on going, so this will get delayed
						print("front_piece.health: ", front_piece.health)
						if front_piece.health <= 0: #if pawn killed it's opponent disable attack_mode
							pawn.attack_mode = false
							square.attack_mode(false)
							front_square.attack_mode(false)
					else:
						pawn.attack_mode = true
						square.attack_mode(true)
						front_square.attack_mode(true)
	print(name, "> attack phase finished")

#IMPORTANT-only runs if end turn is pressed---------------------------------------------
func simulate():
	var player_id = multiplayer.get_unique_id()
	who_clicked_end_turn(player_id)
	rpc("who_clicked_end_turn", player_id)

@rpc("any_peer")#even if you're not using player_id, 
func who_clicked_end_turn(player_id): #you still need to put it as a parameter of the function
	if multiplayer.get_unique_id() == player_id: #If you clicked end turn
		%EndTurn.disabled = true  #disable your end turn so opponent can use end turn
		#print(player_id, ": clicked: ", " %EndTurn.disabled: ", %EndTurn.disabled)
	else: #If the player id was the opponent
		%EndTurn.disabled = false #if opponent clicked end turn it's your turn to click it
		#print(player_id, ": clicked: ", " %EndTurn.disabled: ", %EndTurn.disabled)
	player_move() #move the player first
	opponent_move() #move the opponent's pieces
	attack() #simulate attacks
	update_simulation() #change animation
	view_board()
#IMPORTANT----------------------------------------------

@rpc("any_peer")
func update_simulation():
	for x in range(rows):
		for y in range(cols):
			var pawn = board[x][y]
			var index := calculate_index(x, y)
			var square : Area2D = %Board.get_node("Square" + str(index)) #the node in game corresponding to an index in the board
			if pawn is piece:
				square.visible = true #show the pawn
				if await square.is_pawn_dead(pawn): #run animiation pawn dead if true
					board[x][y] = index #replace the cell with index
					square.visible = false
				else: #if false 
					square.update_visuals(pawn)
			else:
				square.visible = false
@rpc("any_peer")
func player_move():
	print("player_move")
	for x in range(rows):
		for y in range(cols):
			if board[x][y] is piece and board[x][y].team == piece.teams.player:
				var player_piece = board[x][y]
				
				if board[x - 1][y] is piece: #check if forward is a piece(this will decide if pawn will move forward)
					continue #skip the next lines of code and move to the next loop
				
				move_forward(x , y, player_piece)

func move_forward(x : int, y: int, square : piece):
	board[x][y] = (x * cols) + y #return the index number
	if x - 1 < 0: #if piece is at the edge
		board[x][y] = "Q"
	else: #if not on edge move forward
		board[x - 1][y] = square #move up by reducing x axis

@rpc("any_peer")
func opponent_move():
	print("opponent_move")
	#since the 0 index is at the top and last index is at the bottom, if the piece goes down it will keep on going down 
	#we gotta start from the last index to the top to not counter this logical bug
	for x in range(rows):
		for y in range(cols):
			var reverse_x = rows - (x + 1) #first index(0) becomes last index(23)
			var reverse_y = cols - (y + 1) #first index(0) becomes last index(23)
			var player_id = multiplayer.get_unique_id()
			if board[reverse_x][reverse_y] is piece and board[reverse_x][reverse_y].team == piece.teams.opponent:
				var opponent_piece = board[reverse_x][reverse_y]
				if board[reverse_x + 1][reverse_y] is piece: #check if forward is a piece 
					continue #skip the next lines of code and move to the next loop
				#Move if possible
				move_downward(reverse_x, reverse_y, opponent_piece) 

func move_downward(x:int, y:int, square:piece):
	board[x][y] = (x * cols) + y #return the index number
	if x + 1 >= rows - 1 :
		board[x + 1][y] = "B"
	else:
		board[x + 1][y] = square #move down by reducing x axis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EndTurn.connect("pressed", simulate)
	instantiate_board()

func instantiate_board():
	for x in range(rows):
		var row := []
		for y in range(cols):
			row.append((x * cols) + y)
		board.append(row)

func view_board():
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>")
	var player_id = multiplayer.get_unique_id()
	print(" view_board() player_id: ", player_id)
	for x in range(rows):
		var line := ""
		for y in range(cols):
			if board[x][y]is piece:
				line += str(board[x][y].team) + str(board[x][y].name) + " "
			else:
				line += str(board[x][y]) + " "
		print(line)
	print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
