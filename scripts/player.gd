extends CharacterBody2D

@onready var floor_check = $FloorCheck
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound
@onready var pickup_sound = $PickupSound
@onready var walk_sound = $WalkSound

const SPEED = 110.0
const JUMP_VELOCITY = -310.0
const GRAVITY = 980.0
const PUSH_FORCE = 200.0

var has_key = false
var is_picking_up = false
var is_dead = false
var is_invincible = false
var is_paused = false  # add this

func _ready():
	floor_max_angle = deg_to_rad(46)
	floor_snap_length = 8.0
	floor_block_on_wall = true
	floor_stop_on_slope = true
	floor_constant_speed = true
	_setup_player_collision()
	blink()
func _setup_player_collision():
	var collision = $CollisionShape2D
	if not collision:
		return
	
	var col_width = 24.0
	var col_height = 40.0
	
	var hw = col_width / 2
	var hh = col_height / 2
	var top_curve = col_width * 0.2
	
	var points = PackedVector2Array([
		Vector2(-hw, -hh + top_curve),
		Vector2(-hw + top_curve, -hh),
		Vector2(hw - top_curve, -hh),
		Vector2(hw, -hh + top_curve),
		Vector2(hw, hh),
		Vector2(-hw, hh),
	])
	
	var new_shape = ConvexPolygonShape2D.new()
	new_shape.points = points
	collision.shape = new_shape
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F:
			var window = get_window()
			if window.mode == Window.MODE_FULLSCREEN:
				window.mode = Window.MODE_WINDOWED
			else:
				window.mode = Window.MODE_FULLSCREEN
		if event.keycode == KEY_ESCAPE and not is_dead:
			var existing = get_tree().get_first_node_in_group("pause_menu")
			if existing:
				# Already paused — unpause
				get_tree().paused = false
				existing.queue_free()
			else:
				# Not paused — pause
				get_tree().paused = true
				var pause_menu = load("res://scenes/pause_menu.tscn").instantiate()
				pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
				get_tree().root.add_child(pause_menu)
				
				
func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction = 0.0
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction = -1.0
	elif Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction = 1.0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	if is_picking_up:
		pass
	elif is_dead:
		sprite.play("death")
	elif not is_on_floor():
		sprite.play("jump", 1.5)
	elif direction != 0:
		sprite.play("walk")
		if not walk_sound.playing:
			walk_sound.play()
	else:
		sprite.play("idle")
		walk_sound.stop()

	move_and_slide()

	# Anti-corner-surf using raycast
	if is_on_floor() and direction == 0 and abs(velocity.x) < 5:
		floor_check.force_raycast_update()
		if not floor_check.is_colliding():
			velocity.x = sign(get_floor_normal().x) * -80

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var normal = collision.get_normal()
			# Skip if standing on top (even diagonally)
			if normal.y < -0.5:
				continue
			# Push only if player is actively pressing a direction
			if direction == 0:
				continue
			var push_dir_x = -normal.x
			# Push direction must match input direction
			if sign(push_dir_x) != sign(direction):
				continue
			collider.linear_velocity.x = push_dir_x * PUSH_FORCE
		if collider.is_in_group("spikes"):
			die()
func pickup_key():
	is_picking_up = true
	sprite.play("pickup")
	await sprite.animation_finished
	is_picking_up = false

func show_key_dialogue():
	pickup_sound.play()
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_key()
	var dialogue = get_tree().get_first_node_in_group("dialogue")
	if dialogue:
		dialogue.show_text("I found a key! Maybe it opens those doors.")
	var timer = get_tree().create_timer(5.0)
	await timer.timeout
	if not is_inside_tree():
		return
	if not is_instance_valid(self):
		return
	dialogue = get_tree().get_first_node_in_group("dialogue")
	if is_instance_valid(dialogue):
		dialogue.hide_text()

func die():
	if is_dead or is_invincible:
		return
	is_dead = true
	velocity = Vector2.ZERO
	walk_sound.stop()
	death_sound.play()
	sprite.play("death", 1.0)
	sprite.modulate = Color.RED
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()

func blink():
	is_invincible = true
	for i in 10:
		sprite.modulate.a = 0.0
		await get_tree().create_timer(0.07).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.07).timeout
	sprite.modulate = Color.WHITE
	is_invincible = false
