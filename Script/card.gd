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

func attack_pawn(square : Area2D, pawn : piece) -> bool:
	z_index = 100
	
	if pawn.team == piece.teams.opponent:
		animation_player.play("attack_opponent")
	else:
		animation_player.play("attack_player")
	await animation_player.animation_finished
	
	if pawn.team == piece.teams.opponent:
		animation_player.play_backwards("attack_opponent")
	else:
		animation_player.play_backwards("attack_player")
	await animation_player.animation_finished
	z_index = 0
	
	square.update_visuals(pawn) #update the health value
	
	return true

func _on_visibility_changed() -> void:
	if self.visible == false:
		print(name, ": ", visible)
