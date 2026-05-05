extends Control

func _ready():
	# Switch to end menu music
	var music_manager = get_tree().get_first_node_in_group("music_manager")
	if music_manager:
		music_manager.change_music("res://assests/1- Midnight Dreams.ogg")  # ← change to your end music file
	
	var screen_size = get_viewport().get_visible_rect().size

	var bg_texture = TextureRect.new()
	bg_texture.texture = load("res://assests/slika12.png")
	bg_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_texture.custom_minimum_size = screen_size
	bg_texture.size = screen_size
	bg_texture.position = Vector2(0, 0)
	add_child(bg_texture)

	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.3)
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	add_child(overlay)

	var main_panel = Control.new()
	main_panel.anchors_preset = Control.PRESET_FULL_RECT
	add_child(main_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.position = Vector2(screen_size.x / 2 - 200, screen_size.y / 2 - 200)
	vbox.size = Vector2(400, 500)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_panel.add_child(vbox)

	var title = Label.new()
	title.text = "You Escaped Grimhold!"
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0, 1, 0.8))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(title)

	var time_label = Label.new()
	time_label.add_theme_font_size_override("font_size", 28)
	time_label.add_theme_color_override("font_color", Color.WHITE)
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(time_label)

	var msg_label = Label.new()
	msg_label.add_theme_font_size_override("font_size", 20)
	msg_label.add_theme_color_override("font_color", Color.WHITE)
	msg_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(msg_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

	var play_again = Button.new()
	play_again.text = "Play Again"
	play_again.custom_minimum_size = Vector2(250, 55)
	play_again.add_theme_font_size_override("font_size", 24)
	play_again.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	play_again.pressed.connect(func():
		$ButtonSound.play()
		await get_tree().create_timer(0.1).timeout
		_on_play_again_pressed())
	vbox.add_child(play_again)

	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.custom_minimum_size = Vector2(250, 55)
	menu_btn.add_theme_font_size_override("font_size", 24)
	menu_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu_btn.pressed.connect(func():
		$ButtonSound.play()
		await get_tree().create_timer(0.1).timeout
		_on_menu_pressed())
	vbox.add_child(menu_btn)

	if music_manager:
		music_manager.stop_timer()
		var time = music_manager.get_time()
		time_label.text = "Your Time: " + format_time(time)
		msg_label.text = get_message(time)
	else:
		time_label.text = "Your Time: --:--"
		msg_label.text = "You made it out of Grimhold!"

func format_time(seconds):
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

func get_message(seconds):
	if seconds < 120:
		return "Amazing! You're a true dungeon master!"
	elif seconds < 300:
		return "Great job! The dungeon couldn't stop you!"
	else:
		return "You made it out of Grimhold!"

func _on_play_again_pressed():
	var music_manager = get_tree().get_first_node_in_group("music_manager")
	if music_manager:
		music_manager.reset_timer()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F:
			var window = get_window()
			if window.mode == Window.MODE_FULLSCREEN:
				window.mode = Window.MODE_WINDOWED
			else:
				window.mode = Window.MODE_FULLSCREEN
