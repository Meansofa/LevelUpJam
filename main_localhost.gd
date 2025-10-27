extends Node2D

@export var player_packed_scene : PackedScene
@export var opponent_packed_scene : PackedScene

var peer = ENetMultiplayerPeer.new()
const PORT := 9998 #available port
const ADDRESS := "localhost" #IP address (change to the host's ip adress if you want to test with other devices), "local host" if you want to test locally

func _on_host_pressed() -> void:
	_disable_buttons()
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	#connect a signal to when a peer connects
	multiplayer.peer_connected.connect(_on_peer_connected)
	
	var player_scene = player_packed_scene.instantiate()
	add_child(player_scene)

func _on_join_pressed() -> void:
	_disable_buttons()
	
	peer.create_client(ADDRESS, PORT)
	
	multiplayer.multiplayer_peer = peer
	
	var player_scene = player_packed_scene.instantiate()
	add_child(player_scene)
	
	var opponent_scene = opponent_packed_scene.instantiate()
	add_child(opponent_scene)

#This only shows if you're the host
func _on_peer_connected(peer_id):
	print("Player joined!")
	
	var opponent_scene = opponent_packed_scene.instantiate()
	add_child(opponent_scene)

func _disable_buttons():
	$Host.visible = false
	$Host.disabled = true
	$Join.visible = false
	$Join.disabled = true
	%OnlineID.visible = false
	%JoinID.visible = false
