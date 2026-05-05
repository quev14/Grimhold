extends Area2D

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.has_key = true
		body.pickup_key()
		body.show_key_dialogue()
		queue_free()
		var dialogue = get_tree().get_first_node_in_group("dialogue")
		if dialogue:
			dialogue.show_text("I found a key! Maybe it opens those doors.")
			await get_tree().create_timer(6.0).timeout
			if is_instance_valid(dialogue):
				dialogue.hide_text()
