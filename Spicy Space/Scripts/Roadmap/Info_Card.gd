extends Node2D

onready var popup = $Popup
onready var title = $Popup/Title
onready var difficulty = $Popup/Difficuty/difficulty_level

func _ready():
	show_card("", "")

func show_card(game_mode, difficulty_level):
	title.text = game_mode
	difficulty.text = difficulty_level
	yield(get_tree().create_timer(1), "timeout")
	popup.show()

func _on_Close_btn_pressed():
	popup.hide()
