extends StaticBody2D

@onready var collision_shape = $CollisionShape2D

func _ready():
	visible = false
	collision_shape.disabled = true

func appear():
	collision_shape.set_deferred("disabled", false)
	visible = true

func disappear():
	collision_shape.set_deferred("disabled", true)
	visible = false
