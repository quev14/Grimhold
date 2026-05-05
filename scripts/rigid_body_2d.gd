extends RigidBody2D

func _ready():
	lock_rotation = true
	mass = 1.0
	linear_damp = 0.5
	gravity_scale = 1.0
	can_sleep = false
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY
	contact_monitor = true
	max_contacts_reported = 4
	var pm = PhysicsMaterial.new()
	pm.friction = 0.3
	pm.bounce = 0.0
	physics_material_override = pm

func _physics_process(delta):
	linear_velocity.x = move_toward(linear_velocity.x, 0, 50.0)
	angular_velocity = 0
	rotation = 0
func _setup_chamfered_collision():
	var collision = $CollisionShape2D
	if not collision:
		return
	# Get the existing rectangle size (if any) to match
	var size = Vector2(32, 32)  # change to match your box
	if collision.shape is RectangleShape2D:
		size = collision.shape.size
	
	var half = size / 2
	var chamfer = 2.0  # how much to cut off each corner (in pixels)
	
	var points = PackedVector2Array([
		Vector2(-half.x, -half.y + chamfer),
		Vector2(-half.x + chamfer, -half.y),
		Vector2(half.x - chamfer, -half.y),
		Vector2(half.x, -half.y + chamfer),
		Vector2(half.x, half.y - chamfer),
		Vector2(half.x - chamfer, half.y),
		Vector2(-half.x + chamfer, half.y),
		Vector2(-half.x, half.y - chamfer),
	])
	
	var new_shape = ConvexPolygonShape2D.new()
	new_shape.points = points
	collision.shape = new_shape
