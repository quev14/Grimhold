extends Node2D

@onready var letter_w = $letter_w
@onready var letter_a = $letter_a
@onready var letter_d = $letter_d

var current_index = 0
var letters = []
var expected_keys = [KEY_W, KEY_A, KEY_D]

func _ready():
	z_index = -1
	letters = [letter_w, letter_a, letter_d]

	if GameState.tutorial_done:
		for letter in letters:
			letter.visible = false
		set_process_input(false)
		return

	for letter in letters:
		letter.visible = false
	show_letter(0)

func show_letter(index: int):
	if index >= letters.size():
		for letter in letters:
			letter.visible = false
		return
	var letter = letters[index]
	letter.visible = true
	letter.play("idle")

func _input(event):
	if event is InputEventKey and event.pressed:
		if current_index >= letters.size():
			return
		if event.keycode == expected_keys[current_index]:
			letters[current_index].visible = false
			current_index += 1
			if current_index >= letters.size():
				GameState.tutorial_done = true
			show_letter(current_index)
