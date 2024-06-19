extends Node

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var multiplayer_spawner = $MultiplayerSpawner

func _ready():
	multiplayer_spawner.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	open_lobby_list()
	
func spawn_level(data):
	var scene = (load(data) as PackedScene).instantiate()
	return scene;
	
func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	multiplayer_spawner.spawn("res://Scenes/SC_ExtMPTest.tscn")
	$CanvasLayer/Host.hide()
	$CanvasLayer/LobbyContainer/Lobbies.hide()
	$CanvasLayer/Refresh.hide()

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$CanvasLayer/Host.hide()
	$CanvasLayer/LobbyContainer/Lobbies.hide()
	$CanvasLayer/Refresh.hide()
	

func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()
	

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var member_count = Steam.getNumLobbyMembers(lobby)
		
		var bt_join_lobby = Button.new()
		bt_join_lobby.set_text(str(lobby_name, "| Player Count: ", member_count))
		bt_join_lobby.set_size(Vector2(100, 5))
		bt_join_lobby.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		
		$CanvasLayer/LobbyContainer/Lobbies.add_child(bt_join_lobby)
		

func _on_refresh_pressed():
	if $CanvasLayer/LobbyContainer/Lobbies.get_child_count() > 0:
		for n in $CanvasLayer/LobbyContainer/Lobbies.get_children():
			n.queue_free()
	
	open_lobby_list()
