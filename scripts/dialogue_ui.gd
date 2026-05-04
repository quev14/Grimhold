extends CanvasLayer

@onready var label = $PanelContainer/Label

func _ready():
	add_to_group("dialogue")
	hide()  # hides immediately when new scene loads ✅

func show_text(text):
	label.text = text
	show()

func hide_text():
	hide()
