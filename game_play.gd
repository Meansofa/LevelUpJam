extends Node2D

const rows := 6
const cols := 4

var board : Array = []

@export var rook_tres : piece
@export var bishop_tres : piece

var player_cards = []


#called from slot.gd
func place_piece(slot_number : int, card_name : String):
	var player_id = multiplayer.get_unique_id()
	
	who_placed_piece( slot_number, card_name, player_id)
	rpc("who_placed_piece", slot_number, card_name, player_id) #This updates for the other players

func get_card_with_name(card_name : String) -> piece:
	for card in %AllCards.cards:
		if card_name == card.name:
			return card
	var error = piece.new()
	error.name = "ERROR CARD"
	return error

@rpc("any_peer")
func who_placed_piece(slot_number : int, card_name : String, player_id):
	print(player_id, ": placed a piece")
	var card = get_card_with_name(card_name)
	if multiplayer.get_unique_id() == player_id: #if you cliked the button the other player gets damage(Check their screen if their green character has decreased health)
		card.team = piece.teams.player #assign piece to player
		board[rows - 1][slot_number] = card
	else: #if the player clicked the button meaning you take damage
		card.team = piece.teams.opponent #assign piece to opponent
		board[0][slot_number] = card
	
	update_simulation()

func calculate_index(x:int, y:int) -> int:
	return (x*cols) + y

func attack():
	for x in range(rows):
		for y in range(cols):
			var pawn = board[x][y]
			var square : Area2D = %Board.get_node("Square" + str(calculate_index(x, y))) #the node in game corresponding to an index in the board
			if pawn is piece and pawn.team  == piece.teams.player:
				var front_piece = board[x - pawn.attack_direction][y]
				var front_square : Area2D = %Board.get_node("Square" + str(calculate_index(x - pawn.attack_direction, y))) #the node in game corresponding to an index in the board
				if front_piece is piece:
					if front_piece.team == piece.teams.opponent:
						if pawn.attack_mode:
							await square.attack_opponent()
							front_piece.health -= pawn.damage
							front_square.update_visuals(front_piece)
						else:
							pawn.attack_mode = true
					else: 
						pawn.attack_mode = false
			elif pawn is piece and pawn.team  == piece.teams.opponent:
				var front_piece = board[x + pawn.attack_direction][y]
				var front_square : Area2D = %Board.get_node("Square" + str(calculate_index(x + pawn.attack_direction, y))) #the node in game corresponding to an index in the board
				if front_piece is piece:
					if front_piece.team == piece.teams.player:
						if pawn.attack_mode:
							await square.attack_player()
							front_piece.health -= pawn.damage
							front_square.update_visuals(front_piece)
						else:
							pawn.attack_mode = true
					else: 
						pawn.attack_mode = false

func simulate():
	player_move() #move the player first
	opponent_move() #move the opponent's pieces
	attack() #simulate attacks
	update_simulation() #change animation

func update_simulation():
	for x in range(rows):
		for y in range(cols):
			var pawn = board[x][y]
			var index := (x*cols) + y
			var square : Area2D = %Board.get_node("Square" + str(index)) #the node in game corresponding to an index in the board
			if pawn is piece:
				square.visible = true #show the pawn
				square.update_visuals(pawn)
			else:
				square.visible = false

func player_move():
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

func opponent_move():
	#since the 0 index is at the top and last index is at the bottom, if the piece goes down it will keep on going down 
	#we gotta start from the last index to the top to not counter this logical bug
	for x in range(rows):
		for y in range(cols):
			var reverse_x = rows - (x + 1) #first index(0) becomes last index(23)
			var reverse_y = cols - (y + 1) #first index(0) becomes last index(23)
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
	
