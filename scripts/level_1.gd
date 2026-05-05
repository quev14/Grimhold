extends Node2D

func _ready():
	var music_manager = get_tree().get_first_node_in_group("music_manager")
	if music_manager:
		music_manager.change_music("res://assests/Space Horror InGame Music (Exploration) _Clement Panchout.wav")
