extends Node2D

func _on_Lets_btn_pressed():
	SFXManager.button.play()
	self.visible = false
