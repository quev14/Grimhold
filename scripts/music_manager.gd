extends Node

var music
var elapsed_time = 0.0
var is_timing = true

func _ready():
	add_to_group("music_manager")
	music = $Music
	if music:
		music.finished.connect(_on_music_finished)
		await get_tree().create_timer(1.0).timeout
		music.play()

func _process(delta):
	if is_timing:
		elapsed_time += delta

func _on_music_finished():
	if music:
		music.play()

func stop_music():
	if music:
		music.stop()

func start_timer():
	is_timing = true

func stop_timer():
	is_timing = false

func reset_timer():
	elapsed_time = 0.0

func get_time():
	return elapsed_time
