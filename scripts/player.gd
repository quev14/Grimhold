extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound
@onready var pickup_sound = $PickupSound
@onready var walk_sound = $WalkSound
const SPEED = 110.0
const JUMP_VELOCITY = -300.0
const GRAVITY = 980.0
const PUSH_FORCE = 200.0
# Key variable
var has_key = false
var is_picking_up = false
var is_dead = false
var is_invincible = false
var dialogue_timer: SceneTreeTimer = null  # ADDED

func _ready():
	blink()
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F:
			var window = get_window()
			if window.mode == Window.MODE_FULLSCREEN:
				window.mode = Window.MODE_WINDOWED
			else:
				window.mode = Window.MODE_FULLSCREEN
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
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
		if not walk_sound.playing:
			walk_sound.play()
	else:
		sprite.play("idle")
		walk_sound.stop()
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_direction = collision.get_normal() * -1
			collider.linear_velocity.x = push_direction.x * PUSH_FORCE
		if collider.is_in_group("spikes"):
			die()
func pickup_key():
	is_picking_up = true
	sprite.play("pickup")
	await sprite.animation_finished
	is_picking_up = false
func show_key_dialogue():
	pickup_sound.play()
	
	# Show key icon in HUD
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_key()
	
	# Show dialogue text
	var dialogue = get_tree().get_first_node_in_group("dialogue")
	if dialogue:
		dialogue.show_text("I found a key! Maybe it opens those doors.")
	
	# Wait 5 seconds
	await get_tree().create_timer(5.0).timeout
	
	# Safety checks after timer
	if not is_inside_tree():
		return
	if not is_instance_valid(self):
		return
	
	# Hide dialogue
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
	sprite.play("death")
	sprite.modulate = Color.RED
	# ADDED - hide dialogue instantly on death
	var dialogue = get_tree().get_first_node_in_group("dialogue")
	if dialogue:
		dialogue.hide_text()
	dialogue_timer = null
	await get_tree().create_timer(1.5).timeout
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
