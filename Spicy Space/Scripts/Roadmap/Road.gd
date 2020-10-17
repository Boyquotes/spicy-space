extends Node2D

export(bool) var mode_completed = false
export(String, "null", "start", "random", "meteor shower", "dog fight") var game_mode

onready var button = $Button

func _on_Button_pressed():
	if !mode_completed:
		mode_completed = true
		get_tree().get_root().get_node("Main_Scene").prepare_game_mode(game_mode)
	else:
		print("this level already completed")
