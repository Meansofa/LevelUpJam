extends Area2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@export var damage_sfx : AudioStreamWAV
@export var death_sfx : AudioStreamWAV

func update_visuals(pawn : piece):
	change_health(pawn.health)
	change_damage(pawn.damage)
	change_skill(pawn.skill_texture)
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
		animation_player.play("take_damage")
		await animation_player.animation_finished
		animation_player.queue("death")
		GlobalAudioPlayer.add_sfx(death_sfx)
		await animation_player.animation_finished
		return true
	return false

func change_health(value: int):
	%health_label.text = "[b]" + str(value)

func change_damage(value: int):
	if value <= 0:
		%Damage.visible = false
	else:
		%Damage.visible = true
	%damage_label.text = "[b]" + str(value)

func change_texture(value : CompressedTexture2D):
	%pawn_texture.texture_normal = value

func change_skill(value : CompressedTexture2D):
	%skill.texture = value


func attack_pawn(square : Area2D, pawn : piece) -> bool:
	z_index = 100
	
	if pawn.team == pawn.teams.player:
		animation_player.play("attack_down")
	else:
		animation_player.play("attack")
	await animation_player.animation_finished
	z_index = 0
	
	square.update_visuals(pawn) #update the health value
	
	return true

func attack_adjacent_pawn(square : Area2D, pawn : piece, direction: piece.side_directions) -> bool:
	z_index = 100
	
	if pawn.team == pawn.teams.player:
		if direction == piece.side_directions.left:
			animation_player.queue("attack_down_left")
			print("attack_down_left")
		elif direction == piece.side_directions.right:
			animation_player.queue("attack_down_right")
			print("attack_down_right")
	else:
		if direction == piece.side_directions.left:
			animation_player.queue("attack_front_left")
			print("attack_front_left")
		elif direction == piece.side_directions.right:
			animation_player.queue("attack_front_right")
			print("attack_front_right")
		
	await animation_player.animation_finished
	z_index = 0
	
	square.update_visuals(pawn) #update the health value
	
	return true

func play_attack():
	GlobalAudioPlayer.add_sfx(damage_sfx)
