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
