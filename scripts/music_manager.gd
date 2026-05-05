extends Node

var music
var elapsed_time = 0.0
var is_timing = false
var current_track_path = ""

func _ready():
	add_to_group("music_manager")
	music = $Music
	if music:
		music.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if is_timing:
		elapsed_time += delta

func change_music(path: String):
	if path == current_track_path and music.playing:
		return
	current_track_path = path
	if music:
		music.stop()
		music.stream = load(path)
		music.play()

func stop_timer():
	is_timing = false

func start_timer():
	is_timing = true

func reset_timer():
	elapsed_time = 0.0

func stop_music():
	if music:
		music.stop()

func get_time():
	return elapsed_time
