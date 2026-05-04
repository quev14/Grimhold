extends Node2D

static var victory_played = false

func _ready():
	if not victory_played:
		victory_played = true
		$VictorySound.play()
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.has_key = false
