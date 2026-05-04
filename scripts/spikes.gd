extends StaticBody2D

func _ready():
	add_to_group("spikes")
	if $Area2D:
		$Area2D.monitoring = true
		$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.die()
