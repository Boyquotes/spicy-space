extends Node2D

onready var livable_lbl = $livable_lbl
onready var not_livable_lbl = $not_livable_lbl
onready var home_btn = $Home_btn

func prepare_result(result):
	yield(get_tree().create_timer(3), "timeout")
	if result == "livable":
		livable_lbl.visible = true
	elif result == "not livable":
		not_livable_lbl.visible = true
	home_btn.visible = true

func _on_Home_btn_pressed():
	SceneManager.change_scene("Main_Scene")
