extends Node2D

const rows := 6
const cols := 4

var board : Array = []

@export var pick_card : PackedScene

@export var rook_tres : piece
@export var bishop_tres : piece

var player_cards = []

func attack():
	for x in range(rows):
		for y in range(cols):
			var square = %Board.get_node("Square" + str((x*cols) + y))
			if board[x][y] is piece:
				var unknown_piece = board[x][y]
				if board[x][y].team  == piece.teams.player:
					var player_piece = unknown_piece
					var front_square = board[x + player_piece.attack_range][y]
					if front_square is piece and front_square.team == piece.teams.opponent:
						pass
				var card = board[x][y]
				square.visible = true #show the card
				square.change_health(card.health)
				square.change_damage(card.damage)
			else:
				square.visible = false

func place_piece(slot : int, card : Area2D):
	player_move()
	#card.position += Vector2(100, 100)
	var rook = rook_tres.duplicate()
	rook.team = piece.teams.player #assign piece to player
	board[rows - 1][slot] = rook
	view_board()

func simulate():
	for x in range(rows):
		for y in range(cols):
			var square = %Board.get_node("Square" + str((x*cols) + y))
			if typeof(board[x][y]) != TYPE_INT:
				var card = board[x][y]
				square.visible = true #show the card
				square.change_health(card.health)
				square.change_damage(card.damage)
			else:
				square.visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if board == []:
			return
		if Input.is_key_pressed(KEY_A):
			simulate()
		if Input.is_key_pressed(KEY_Q):
			player_move()
			opponent_move()
		if Input.is_key_pressed(KEY_1):
			player_move()
			var rook = rook_tres.duplicate()
			rook.team = piece.teams.player #assign piece to player
			board[rows - 1][0] = rook
		if Input.is_key_pressed(KEY_2):
			player_move()
			var rook = rook_tres.duplicate()
			rook.team = piece.teams.player #assign piece to player
			board[rows - 1][1] = rook
		if Input.is_key_pressed(KEY_5):
			opponent_move()
			var bishop = bishop_tres.duplicate()
			bishop.team = piece.teams.opponent #assign piece to oppoonent
			board[0][0] = bishop
		
		view_board()

func player_move():
	for x in range(rows):
		for y in range(cols):
			if board[x][y] is piece and board[x][y].team == piece.teams.player:
				var player_piece = board[x][y]
				
				if board[x - 1][y] is piece: #check if forward is a piece(this will decide if pawn will move forward)
					#var unknown_piece = board[x - 1][y]
					#if unknown_piece.team  == piece.teams.player:
						#board[x][y] = player_piece
					#elif unknown_piece.team  == piece.teams.opponent:
						#unknown_piece.health -= player_piece.damage
						#if unknown_piece.health > 0: #if the piece in the front is still alive after attacking then dont move
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
					#var unknown_piece = board[reverse_x + 1][reverse_y]
					#if unknown_piece.team  == piece.teams.opponent:#if it's your ally blocking the way don't move
						#board[reverse_x][reverse_y] = opponent_piece
					#elif unknown_piece.team  == piece.teams.player: #if it's an enemy don't move
						#if unknown_piece.health > 0: #if the piece in the front is still alive after attacking then dont move
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
	instantiate_board()

func instantiate_board():
	for x in range(rows):
		var row := []
		for y in range(cols):
			row.append((x * cols) + y)
		board.append(row)
	
	view_board()
	
func view_board():
	print("-------------------")
	for x in range(rows):
		var line := ""
		for y in range(cols):
			line += str(board[x][y]) + " "
		print(line)
	print("-------------------")
