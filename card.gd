extends Area2D

func change_health(value: int):
	%health_label.text = "[b]" + str(value)

func change_damage(value: int):
	%damage_label.text = "[b]" + str(value)

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
