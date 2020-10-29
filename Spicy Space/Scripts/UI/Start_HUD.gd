extends Node2D

func _on_Lets_btn_pressed():
	SFXManager.button.play()
	SceneManager.show_transition()
	yield(get_tree().create_timer(0.8), "timeout")
	self.visible = false
