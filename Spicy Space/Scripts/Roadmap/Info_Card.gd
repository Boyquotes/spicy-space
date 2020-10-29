extends CanvasLayer

onready var popup = $Popup
onready var title = $Popup/Title
onready var descriptions = $Popup/Descriptions
onready var difficulty = $Popup/Difficulty
onready var difficulty_lbl = $Popup/Difficulty/difficulty_level_lbl

var _difficulty_level

func show_card(game_mode, difficulty_level):
	_difficulty_level = difficulty_level
	title.text = str(Global.game_mode.keys()[game_mode])
	#description
	var desc
	for desc_no in descriptions.get_child_count():
		desc = descriptions.get_child(desc_no)
		if desc_no == game_mode:
			desc.visible = true
		else:
			desc.visible = false
	#difficulty
	difficulty_lbl.text = str(Global.difficulty.keys()[difficulty_level])
	#set color to difficulty text
	if difficulty_level == Global.difficulty.null:
		difficulty.visible = false
	elif difficulty_level == Global.difficulty.easy:
		difficulty_lbl.modulate = Color.green
	elif difficulty_level == Global.difficulty.normal:
		difficulty_lbl.modulate = Color.yellow
	elif difficulty_level == Global.difficulty.hard:
		difficulty_lbl.modulate = Color.red 
	popup.show()

func _on_Close_btn_pressed():
	SFXManager.button.play()
	popup.hide()

func _on_Go_btn_pressed():
	SFXManager.button.play()
	popup.hide()
	SceneManager.show_transition()
	yield(get_tree().create_timer(0.8), "timeout")
	get_parent().go_to_road(_difficulty_level)
