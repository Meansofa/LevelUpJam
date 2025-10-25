extends Resource
class_name piece #can be searched while adding a new resource type

enum teams {player, opponent}
@export var team : teams = teams.player

@export var health := 1
@export var damage := 1

enum directions {forward, down, left, right}
@export var attack_direction: directions = directions.forward
@export var attack_range : int = 1
