extends Control

@export var first_level = "res://scenes/level_1.tscn"

var settings_panel
var main_panel
var volume_slider
var fullscreen_checkbox
var button_sound

func _ready():
	button_sound = $ButtonSound

	# Background image
	var bg_texture = TextureRect.new()
	bg_texture.texture = load("res://assests/slika12.png")  # change this to your image path
	bg_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg_texture)

	# Dark overlay so buttons are readable
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.3) 
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	# Main panel
	main_panel = Control.new()
	main_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.set_anchor(SIDE_LEFT, 0.5)
	vbox.set_anchor(SIDE_RIGHT, 0.5)
	vbox.set_anchor(SIDE_TOP, 0.5)
	vbox.set_anchor(SIDE_BOTTOM, 0.5)
	vbox.set_offset(SIDE_LEFT, -125)
	vbox.set_offset(SIDE_RIGHT, 125)
	vbox.set_offset(SIDE_TOP, -100)
	vbox.set_offset(SIDE_BOTTOM, 100)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_panel.add_child(vbox)

	# Play button
	var play_btn = Button.new()
	play_btn.text = "Play"
	play_btn.custom_minimum_size = Vector2(250, 55)
	play_btn.add_theme_font_size_override("font_size", 24)
	play_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	play_btn.pressed.connect(_on_play_pressed)
	vbox.add_child(play_btn)

	# Settings button
	var settings_btn = Button.new()
	settings_btn.text = "Settings"
	settings_btn.custom_minimum_size = Vector2(250, 55)
	settings_btn.add_theme_font_size_override("font_size", 24)
	settings_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	settings_btn.pressed.connect(_on_settings_pressed)
	vbox.add_child(settings_btn)

	# Quit button
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

	var s_bg = ColorRect.new()
	s_bg.color = Color(0, 0, 0, 0.05)
	s_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_panel.add_child(s_bg)

	var s_vbox = VBoxContainer.new()
	s_vbox.add_theme_constant_override("separation", 20)
	s_vbox.set_anchor(SIDE_LEFT, 0.5)
	s_vbox.set_anchor(SIDE_RIGHT, 0.5)
	s_vbox.set_anchor(SIDE_TOP, 0.5)
	s_vbox.set_anchor(SIDE_BOTTOM, 0.5)
	s_vbox.set_offset(SIDE_LEFT, -150)
	s_vbox.set_offset(SIDE_RIGHT, 150)
	s_vbox.set_offset(SIDE_TOP, -175)
	s_vbox.set_offset(SIDE_BOTTOM, 175)
	s_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	settings_panel.add_child(s_vbox)

	var s_title = Label.new()
	s_title.text = "Settings"
	s_title.add_theme_font_size_override("font_size", 40)
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

	volume_slider = HSlider.new()
	volume_slider.min_value = -40
	volume_slider.max_value = 0
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	volume_slider.custom_minimum_size = Vector2(300, 30)
	volume_slider.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	volume_slider.value_changed.connect(_on_volume_slider_changed)
	s_vbox.add_child(volume_slider)

	fullscreen_checkbox = CheckBox.new()
	fullscreen_checkbox.text = "Fullscreen"
	fullscreen_checkbox.add_theme_font_size_override("font_size", 20)
	fullscreen_checkbox.add_theme_color_override("font_color", Color.WHITE)
	fullscreen_checkbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fullscreen_checkbox.toggled.connect(_on_fullscreen_checkbox_toggled)
	s_vbox.add_child(fullscreen_checkbox)

	var back_btn = Button.new()
	back_btn.text = "Back"
	back_btn.custom_minimum_size = Vector2(250, 55)
	back_btn.add_theme_font_size_override("font_size", 24)
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.pressed.connect(_on_back_pressed)
	s_vbox.add_child(back_btn)

func _on_play_pressed():
	button_sound.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(first_level)

func _on_settings_pressed():
	button_sound.play()
	main_panel.hide()
	settings_panel.show()

func _on_quit_pressed():
	button_sound.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()

func _on_back_pressed():
	button_sound.play()
	settings_panel.hide()
	main_panel.show()

func _on_volume_slider_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_fullscreen_checkbox_toggled(toggled):
	var window = get_window()
	if toggled:
		window.mode = Window.MODE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F:
			var window = get_window()
			if window.mode == Window.MODE_FULLSCREEN:
				window.mode = Window.MODE_WINDOWED
			else:
				window.mode = Window.MODE_FULLSCREEN
