extends MultiplayerSpawner

@export var playerScene : PackedScene

func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)


var allPlayers = {}

func spawnPlayer(data):
	var newPlayer = playerScene.instantiate()
	newPlayer.set_multiplayer_authority(data)
	allPlayers[data] = newPlayer
	return newPlayer
	
	
func removePlayer(data):
	allPlayers[data].queue_free()
	allPlayers.erase(data)
