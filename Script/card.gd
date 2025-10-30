extends Area2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer

func update_visuals(pawn : piece):
	change_health(pawn.health)
	change_damage(pawn.damage)
	var player_id = multiplayer.get_unique_id()
	if player_id == 1: #IF host
		if pawn.team == piece.teams.player:
			change_texture(pawn.player_pawn_texture)
		else:
			change_texture(pawn.opponent_pawn_texture)
	else: #IF join
		if pawn.team == piece.teams.player:
			change_texture(pawn.opponent_pawn_texture)
		else:
			change_texture(pawn.player_pawn_texture)

func attack_mode(yes : bool):
	if yes:
		%Damage.modulate = Color.RED
	else:
		%Damage.modulate = Color.WHITE

func is_pawn_dead(pawn : piece) -> bool:
	if pawn.health <= 0:
		change_health(pawn.health) #just to make sure before animation they know their pawn is dead
		print(pawn.team, pawn, ": dead")
		if animation_player.is_playing():
			animation_player.queue("death")
		else:
			animation_player.play("death")
		await animation_player.animation_finished
		return true
	#print(pawn.name, ": health: ", pawn.health)
	return false

func change_health(value: int):
	%health_label.text = "[b]" + str(value)

func change_damage(value: int):
	%damage_label.text = "[b]" + str(value)

func change_texture(value : CompressedTexture2D):
	%pawn_texture.texture_normal = value

func attack_pawn(square : Area2D, pawn : piece) -> bool:
	z_index = 100
	
	animation_player.play("attack")
	await animation_player.animation_finished
	z_index = 0
	
	square.update_visuals(pawn) #update the health value
	
	return true
