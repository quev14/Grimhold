extends StaticBody2D

@export var next_level = "res://scenes/level_2.tscn"

func _ready():
	$Area2D.monitoring = true
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D and body.has_key:
		var dialogue = get_tree().get_first_node_in_group("dialogue")
		if is_instance_valid(dialogue):
			dialogue.hide_text()
		# Hide key icon
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.hide_key()
		body.has_key = false
		get_tree().change_scene_to_file(next_level)
	elif body is CharacterBody2D and not body.has_key:
		if get_tree():
			var dialogue = get_tree().get_first_node_in_group("dialogue")
			if dialogue:
				dialogue.show_text("Hm, these doors are locked. I need to find a key.")

func _on_body_exited(body):
	if body is CharacterBody2D:
		if get_tree():
			var dialogue = get_tree().get_first_node_in_group("dialogue")
			if is_instance_valid(dialogue):
				dialogue.hide_text()
