extends Node2D

@export var win_sfx : AudioStreamWAV
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@export var player_1_texture : CompressedTexture2D
@export var player_2_texture : CompressedTexture2D

var current_round := 1

func new_round():
	%HealthBar.value = 100

func take_damage() -> float:
	%HealthBar.take_damage(%HealthBar.step)
	animation_player.play("take_damage")
	return %HealthBar.value

func player_tag(player_name : String):
	%playertag.text = "[b][center]" + player_name

@rpc("any_peer")
func change_player_frame(operator : String):
	if operator == "host":
		%playerframe.texture = player_1_texture
	else:
		%playerframe.texture = player_2_texture

func round_win():
	%Crown.add_crown()
	GlobalAudioPlayer.add_sfx(win_sfx)

func get_crown() -> int:
	return %Crown.curr_crown
