extends StaticBody2D

@export var bridge_path : NodePath
@export var bridge_path_2 : NodePath
@export var bridge_path_3 : NodePath

@onready var sprite = $Sprite2D
@onready var area = $Area2D

func _ready():
	add_to_group("pressure_plate")
	if area:
		area.monitoring = true
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	pulse()

func pulse():
	while true:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(1.5, 1.5, 0.5), 0.8)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.8)
		await tween.finished

func _on_body_entered(body):
	if body is CharacterBody2D or body is RigidBody2D:
		sprite.modulate = Color(0.5, 1.5, 0.5)
		var bridge = get_node_or_null(bridge_path)
		var bridge2 = get_node_or_null(bridge_path_2)
		var bridge3 = get_node_or_null(bridge_path_3)
		if bridge:
			bridge.appear()
		if bridge2:
			bridge2.appear()
		if bridge3:
			bridge3.appear()
		if body is CharacterBody2D:
			body.velocity.y = 0

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		sprite.modulate = Color(1, 1, 1)
		var bridge = get_node_or_null(bridge_path)
		var bridge2 = get_node_or_null(bridge_path_2)
		var bridge3 = get_node_or_null(bridge_path_3)
		if bridge:
			bridge.disappear()
		if bridge2:
			bridge2.disappear()
		if bridge3:
			bridge3.disappear()
		pulse()
