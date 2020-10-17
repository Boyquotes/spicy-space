extends Node2D

export(bool) var mode_completed = false
export(String, "null", "start", "random", "meteor shower", "dog fight") var game_mode

func _on_Button_pressed():
	get_tree().get_root().get_node("New_Game").prepare_game_mode(game_mode)
	
