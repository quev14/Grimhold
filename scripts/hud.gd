extends CanvasLayer

@onready var key_icon = $KeyIcon
@onready var timer_label = $TimerLabel

func _ready():
	add_to_group("hud")
	key_icon.hide()

func _process(delta):
	# Read time from MusicManager autoload
	if get_tree().get_first_node_in_group("music_manager"):
		var time = get_tree().get_first_node_in_group("music_manager").elapsed_time
		timer_label.text = format_time(time)

func format_time(seconds):
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func show_key():
	key_icon.show()

func hide_key():
	key_icon.hide()
