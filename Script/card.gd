extends Area2D

func update_visuals(pawn : piece):
	change_health(pawn.health)
	change_damage(pawn.damage)
	change_texture(pawn.pawn_texture)

func is_pawn_dead(pawn : piece) -> bool:
	if pawn.health <= 0:
		%AnimationPlayer.play("death")
		return true
	#print(pawn.name, ": health: ", pawn.health)
	return false

func change_health(value: int):
	%health_label.text = "[b]" + str(value)
	

func change_damage(value: int):
	%damage_label.text = "[b]" + str(value)

func change_texture(value : CompressedTexture2D):
	%pawn_texture.texture_normal = value

func attack_opponent() -> bool:
	z_index = 100
	%AnimationPlayer.play("attack_opponent")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play_backwards("attack_opponent")
	await %AnimationPlayer.animation_finished
	z_index = 0
	
	return true

func attack_player() -> bool:
	z_index = 100
	%AnimationPlayer.play("attack_player")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play_backwards("attack_player")
	await %AnimationPlayer.animation_finished
	z_index = 0
	
	return true
