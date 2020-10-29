extends Node2D

func _on_Start_btn_pressed():
	SFXManager.button.play()
	SceneManager.change_scene("Game_Scene")
