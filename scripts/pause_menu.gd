extends CanvasLayer

var button_sound
var settings_panel
var main_panel

func _ready():
	add_to_group("pause_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS

	if has_node("ButtonSound"):
		button_sound = $ButtonSound

	var screen_size = get_viewport().get_visible_rect().size

	# Transparent overlay — change alpha to taste:
	# 0.0 = fully transparent (game fully visible)
	# 0.2 = slight dim
	# 0.4 = medium dim
	# 0.6 = strong dim
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.2)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	main_panel = Control.new()
	main_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.position = Vector2(screen_size.x / 2 - 125, screen_size.y / 2 - 175)
	vbox.size = Vector2(250, 350)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_panel.add_child(vbox)

	var title = Label.new()
	title.text = "Paused"
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color(0, 1, 0.8))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(title)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

	var continue_btn = Button.new()
	continue_btn.text = "Continue"
	continue_btn.custom_minimum_size = Vector2(250, 55)
	continue_btn.add_theme_font_size_override("font_size", 24)
	continue_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	continue_btn.pressed.connect(_on_continue_pressed)
	vbox.add_child(continue_btn)

	var settings_btn = Button.new()
	settings_btn.text = "Settings"
	settings_btn.custom_minimum_size = Vector2(250, 55)
	settings_btn.add_theme_font_size_override("font_size", 24)
	settings_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	settings_btn.pressed.connect(_on_settings_pressed)
	vbox.add_child(settings_btn)

	var menu_btn = Button.new()
	menu_btn.text = "Main Menu"
	menu_btn.custom_minimum_size = Vector2(250, 55)
	menu_btn.add_theme_font_size_override("font_size", 24)
	menu_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu_btn.pressed.connect(_on_menu_pressed)
	vbox.add_child(menu_btn)

	var quit_btn = Button.new()
	quit_btn.text = "Quit"
	quit_btn.custom_minimum_size = Vector2(250, 55)
	quit_btn.add_theme_font_size_override("font_size", 24)
	quit_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)

	# Settings panel
	settings_panel = Control.new()
	settings_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_panel.hide()
	add_child(settings_panel)

	var s_overlay = ColorRect.new()
	s_overlay.color = Color(0, 0, 0, 0.85)
	s_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_panel.add_child(s_overlay)

	var s_vbox = VBoxContainer.new()
	s_vbox.add_theme_constant_override("separation", 20)
	s_vbox.position = Vector2(screen_size.x / 2 - 150, screen_size.y / 2 - 175)
	s_vbox.size = Vector2(300, 350)
	s_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	settings_panel.add_child(s_vbox)

	var s_title = Label.new()
	s_title.text = "Settings"
	s_title.add_theme_font_size_override("font_size", 36)
	s_title.add_theme_color_override("font_color", Color(0, 1, 0.8))
	s_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	s_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s_vbox.add_child(s_title)

	var vol_label = Label.new()
	vol_label.text = "Volume"
	vol_label.add_theme_font_size_override("font_size", 20)
	vol_label.add_theme_color_override("font_color", Color.WHITE)
	vol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vol_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s_vbox.add_child(vol_label)

	var volume_slider = HSlider.new()
	volume_slider.min_value = -40
	volume_slider.max_value = 0
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	volume_slider.custom_minimum_size = Vector2(250, 30)
	volume_slider.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	volume_slider.value_changed.connect(func(value): AudioServer.set_bus_volume_db(0, value))
	s_vbox.add_child(volume_slider)

	var fullscreen_checkbox = CheckBox.new()
	fullscreen_checkbox.text = "Fullscreen"
	fullscreen_checkbox.add_theme_font_size_override("font_size", 20)
	fullscreen_checkbox.add_theme_color_override("font_color", Color.WHITE)
	fullscreen_checkbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fullscreen_checkbox.toggled.connect(func(toggled):
		var window = get_window()
		if toggled:
			window.mode = Window.MODE_FULLSCREEN
		else:
			window.mode = Window.MODE_WINDOWED)
	s_vbox.add_child(fullscreen_checkbox)

	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.custom_minimum_size = Vector2(250, 55)
	back_btn.add_theme_font_size_override("font_size", 24)
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.pressed.connect(_on_back_pressed)
	s_vbox.add_child(back_btn)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			_on_continue_pressed()

func _on_continue_pressed():
	if button_sound:
		button_sound.play()
	get_tree().paused = false
	queue_free()

func _on_settings_pressed():
	if button_sound:
		button_sound.play()
	main_panel.hide()
	settings_panel.show()

func _on_back_pressed():
	if button_sound:
		button_sound.play()
	settings_panel.hide()
	main_panel.show()

func _on_menu_pressed():
	if button_sound:
		button_sound.play()
	# Hide dialogue before leaving so it doesn't linger on next game
	var dialogue = get_tree().get_first_node_in_group("dialogue")
	if is_instance_valid(dialogue):
		dialogue.hide_text()
	# Unpause before scene change
	get_tree().paused = false
	# Wait briefly for button sound to play
	await get_tree().create_timer(0.1).timeout
	# Free pause menu first (it lives in root, so it survives scene change otherwise)
	queue_free()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed():
	if button_sound:
		button_sound.play()
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
