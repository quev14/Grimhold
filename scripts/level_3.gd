extends Node2D

static var victory_played = false

func _ready():
	print("Level 3 loaded! victory_played: ", victory_played)
	if not victory_played:
		victory_played = true
		print("Playing victory sound!")
		$VictorySound.play()
	else:
		print("Victory already played, skipping")
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.has_key = false
