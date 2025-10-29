extends Node2D

@export var player_packed_scene : PackedScene
@export var opponent_packed_scene : PackedScene

var peer = NodeTunnelPeer.new()
var localpeer = ENetMultiplayerPeer.new()
const PORT := 9998 #port to use, Nodetunnel only has this node available
const ADDRESS := "relay.nodetunnel.io" #IP address (change to the host's ip adress if you want to test with other devices), "local host" if you want to test locally
const localADDRESS := "localhost"

var player_side_scenes := []
var opponent_side_scenes := []

var use_local_multiplayer := false

func _ready() -> void:
	%Loading.visible = false
	%required.visible = false
	%PlayerDisconnected.visible = false

	multiplayer.multiplayer_peer = peer
	peer.connect_to_relay(ADDRESS, PORT)
	
	await peer.relay_connected
	
	%OnlineID.text = peer.online_id

func _on_host_pressed() -> void:
	_disable_buttons()
	if use_local_multiplayer:
		localpeer.create_server(PORT)
		multiplayer.multiplayer_peer = localpeer
	else:
		peer.host()
	
		%Loading.visible = true
		await peer.hosting
		%Loading.visible = false
		
		DisplayServer.clipboard_set(peer.online_id) #copy the online id to the clipboard
	
	#connect a signal to when a peer connects
	multiplayer.peer_connected.connect(_on_peer_connected)
	%WaitingForPlayer.visible = true
	var player_scene = player_packed_scene.instantiate()
	add_child(player_scene)
	player_side_scenes.append(player_scene)

func _on_join_pressed() -> void:
	if use_local_multiplayer:
		localpeer.create_client(localADDRESS, PORT)
		multiplayer.multiplayer_peer = localpeer
		%Loading.visible = true
	else:
		if %JoinID.text == "":
			%required.visible = true
			return

		%required.visible = false
		peer.join(%JoinID.text)
	
		%Loading.visible = true
		await peer.joined
	
	%Loading.visible = false
	_disable_buttons()
	
	var player_scene = player_packed_scene.instantiate()
	add_child(player_scene)
	
	var opponent_scene = opponent_packed_scene.instantiate()
	add_child(opponent_scene)
	
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

#This only shows if you're the host
func _on_peer_connected(peer_id):
	print("Player: ", peer_id, " joined!")
	%WaitingForPlayer.visible = false
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	var opponent_scene = opponent_packed_scene.instantiate()
	add_child(opponent_scene)

func _on_peer_disconnected(peer_id):
	print("Player: ", peer_id, " disconnected!")
	%PlayerDisconnected.visible = true
	$%disconnected_label.text = "[b]Player " + str(peer_id) + " DISCONNECTED."

func _disable_buttons():
	%Menu.visible = false
	%Host.visible = false
	%Host.disabled = true
	%Join.visible = false
	%Join.disabled = true
	%OnlineID.visible = false
	%JoinID.visible = false
	%local_checkbox.visible = false
	#%Settings.visible = false
	#%Settings.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE

func _enable_buttons():
	%Menu.visible = true
	%Host.visible = true
	%Host.disabled = false
	%Join.visible = true
	%Join.disabled = false
	%OnlineID.visible = true
	%JoinID.visible = true
	%local_checkbox.visible = true
	#%Settings.visible = true
	#%Settings.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP

func restart():
	get_tree().reload_current_scene()

func _disable_non_local_buttons():
	%OnlineID.visible = false
	%JoinID.visible = false

func enable_non_local_buttons():
	%OnlineID.visible = true
	%JoinID.visible = true

func _on_check_button_toggled(toggled_on: bool) -> void:
	use_local_multiplayer = toggled_on
	if use_local_multiplayer:
		_disable_non_local_buttons()
	else:
		enable_non_local_buttons()
