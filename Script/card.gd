extends Area2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer

func update_visuals(pawn : piece):
	change_health(pawn.health)
	change_damage(pawn.damage)
	change_texture(pawn.pawn_texture)

func is_pawn_dead(pawn : piece) -> bool:
	if pawn.health <= 0:
		print(pawn.team, pawn, ": dead")
		if animation_player.is_playing():
			animation_player.queue("death")
		else:
			animation_player.play("death")
		return true
	#print(pawn.name, ": health: ", pawn.health)
	return false

func change_health(value: int):
	%health_label.text = "[b]" + str(value)
	

func change_damage(value: int):
	%damage_label.text = "[b]" + str(value)

func change_texture(value : CompressedTexture2D):
	%pawn_texture.texture_normal = value

func attack_opponent(opponent_square : Area2D, opponent_piece : piece) -> bool:
	z_index = 100
	animation_player.play("attack_opponent")
	await animation_player.animation_finished
	animation_player.play_backwards("attack_opponent")
	await animation_player.animation_finished
	z_index = 0
	
	opponent_square.update_visuals(opponent_piece) #update the health value
	
	return true

func attack_player(player_square : Area2D, player_piece : piece) -> bool:
	z_index = 100
	animation_player.play("attack_player")
	await animation_player.animation_finished
	animation_player.play_backwards("attack_player")
	await animation_player.animation_finished
	z_index = 0
	
	player_square.update_visuals(player_piece) #update the health value
	
	return true
