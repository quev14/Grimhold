extends AnimatableBody2D

@export var move_speed = 1.5
@export var move_distance = 100.0
@export var direction = "horizontal"  # "horizontal" or "vertical"

var start_position : Vector2
var time : float = 0.0

func _ready():
	start_position = position

func _physics_process(delta):
	time += delta
	if direction == "horizontal":
		# Moves right from start position only
		position.x = start_position.x + (sin(time * move_speed) + 1) * (move_distance / 2)
	elif direction == "vertical":
		# Moves up from start position only
		position.y = start_position.y - (sin(time * move_speed) + 1) * (move_distance / 2)
