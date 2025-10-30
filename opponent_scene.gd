extends Node2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@export var player_1_texture : CompressedTexture2D
@export var player_2_texture : CompressedTexture2D

func take_damage():
	%HealthBar.take_damage(%HealthBar.step)
	animation_player.play("take_damage")

func player_tag(player_name : String):
	%playertag.text = "[b][center]" + player_name

@rpc("any_peer")
func change_player_frame(operator : String):
	if operator == "host":
		%playerframe.texture = player_1_texture
	else:
		%playerframe.texture = player_2_texture
