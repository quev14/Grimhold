extends StaticBody2D

@export var bridge_path : NodePath
@export var bridge_path_2 : NodePath
@export var bridge_path_3 : NodePath

@onready var sprite = $Sprite2D
@onready var area = $Area2D

var bodies_on_plate = []
var pulse_tween : Tween = null

func _ready():
	add_to_group("pressure_plate")
	if area:
		area.monitoring = true
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	start_pulse()

func start_pulse():
	stop_pulse()
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(sprite, "modulate", Color(1.5, 1.5, 0.5), 0.8)
	pulse_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.8)

func stop_pulse():
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
		pulse_tween = null

func _on_body_entered(body):
	if not (body is CharacterBody2D or body is RigidBody2D):
		return
	if body in bodies_on_plate:
		return
	bodies_on_plate.append(body)
	# Activate only when first body lands
	if bodies_on_plate.size() == 1:
		stop_pulse()
		sprite.modulate = Color(0.5, 1.5, 0.5)
		_activate_bridges()
	if body is CharacterBody2D:
		body.velocity.y = 0

func _on_body_exited(body):
	if body in bodies_on_plate:
		bodies_on_plate.erase(body)
	# Only deactivate when ALL bodies have left
	if bodies_on_plate.is_empty():
		sprite.modulate = Color(1, 1, 1)
		_deactivate_bridges()
		start_pulse()

func _activate_bridges():
	for path in [bridge_path, bridge_path_2, bridge_path_3]:
		var bridge = get_node_or_null(path)
		if bridge:
			bridge.appear()

func _deactivate_bridges():
	for path in [bridge_path, bridge_path_2, bridge_path_3]:
		var bridge = get_node_or_null(path)
		if bridge:
			bridge.disappear()
