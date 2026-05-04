extends RigidBody2D

func _ready():
	lock_rotation = true
	mass = 1.0
	linear_damp = 0.5
	gravity_scale = 1.0
	

func _physics_process(delta):
	linear_velocity.x = move_toward(linear_velocity.x, 0, 50.0)
	
