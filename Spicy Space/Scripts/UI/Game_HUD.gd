extends Node2D

onready var gameover_hud = $GameOver_HUD
onready var highscore_lbl = $GameOver_HUD/HighScore_lbl
onready var fail_lbl = $GameOver_HUD/Fail_lbl
onready var paused_hud = $Paused_HUD
onready var pause_btn = $Pause_btn


func assign_playerdata(whichdata, value):
	if whichdata == "highscore":
		UserDataManager.save_userdata(whichdata, value)
		var highscore = str(UserDataManager.load_userdata(whichdata)) # update high score
		highscore_lbl.text = "Highscore: " + highscore # assign high score to text
	if whichdata == "fail":
		UserDataManager.save_userdata(whichdata, value)
		var fail = str(UserDataManager.load_userdata(whichdata))
		fail_lbl.text = "Fail: " + fail

func game_over():
	pause_btn.visible = false
	gameover_hud.visible = true
	assign_playerdata("highscore", Global.score)
	assign_playerdata("fail", Global.fail_counter)

func _on_Restart_btn_pressed():
	gameover_hud.visible = false
	SceneManager.change_scene("Main_Scene")

func _on_Pause_btn_pressed():
	paused_hud.visible = true
	pause_btn.visible = false
	get_tree().paused = true

func _on_Continue_btn_pressed():
	paused_hud.visible = false
	pause_btn.visible = true
	get_tree().paused = false
