extends CanvasLayer

onready var popup = $Popup
onready var title = $Popup/Title
onready var difficulty = $Popup/Difficuty/difficulty_level

func show_card(game_mode, difficulty_level):
	title.text = game_mode
	difficulty.text = difficulty_level
	#set color to difficulty text
	if difficulty_level == "easy":
		difficulty.modulate = Color.green
	elif difficulty_level == "normal":
		difficulty.modulate = Color.yellow
	elif difficulty_level == "hard":
		difficulty.modulate = Color.red 
	yield(get_tree().create_timer(.5), "timeout")
	popup.show()

func _on_Close_btn_pressed():
	popup.hide()

func _on_Go_btn_pressed():
	popup.hide()
	get_parent().go_to_road()
