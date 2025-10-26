extends Resource
class_name piece #can be searched while adding a new resource type

enum teams {player, opponent}
@export var name : String
@export var team : teams = teams.player
@export var pawn_texture : CompressedTexture2D

@export var health := 1
@export var damage := 1
@export var elixer := 1

#enum directions {forward, down, left, right}
#@export var attack_direction: directions = directions.forward
@export_flags("forward:1", "far_forward:2") var attack_direction = 1
@export var attack_mode : bool
