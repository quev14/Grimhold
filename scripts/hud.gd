extends CanvasLayer

@onready var key_icon = $KeyIcon
@onready var timer_label = $TimerLabel

var was_paused = false

func _ready():
	add_to_group("hud")
	process_mode = Node.PROCESS_MODE_ALWAYS
	key_icon.hide()
	
	# Timer — top-left corner
	timer_label.set_anchor(SIDE_LEFT, 0.0)
	timer_label.set_anchor(SIDE_RIGHT, 0.0)
	timer_label.set_anchor(SIDE_TOP, 0.0)
	timer_label.set_anchor(SIDE_BOTTOM, 0.0)
	timer_label.set_offset(SIDE_LEFT, 10)
	timer_label.set_offset(SIDE_RIGHT, 130)
	timer_label.set_offset(SIDE_TOP, 10)
	timer_label.set_offset(SIDE_BOTTOM, 40)
	
	# Key icon — directly below the timer
	key_icon.position = Vector2(40, 70)

func _process(_delta):
	var music_manager = get_tree().get_first_node_in_group("music_manager")
	if music_manager:
		timer_label.text = format_time(music_manager.elapsed_time)

	# Only update modulate when pause state changes
	var paused_now = get_tree().paused
	if paused_now != was_paused:
		was_paused = paused_now
		if paused_now:
			timer_label.modulate = Color(1, 1, 1, 0.3)
			key_icon.modulate = Color(1, 1, 1, 0.3)
		else:
			timer_label.modulate = Color(1, 1, 1, 1)
			key_icon.modulate = Color(1, 1, 1, 1)

func format_time(seconds):
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func show_key():
	key_icon.show()

func hide_key():
	key_icon.hide()
