extends Node2D

@onready var animation_player : AnimationPlayer = %AnimationPlayer
@export var player_1_texture : CompressedTexture2D
@export var player_2_texture : CompressedTexture2D

var current_round := 1

func _ready() -> void:
	%Round.visible = false

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
	display_round()

func display_round():
	%Round.visible = true
	%round_label.text = "[b][center]Round " + str(current_round) + " Win"
