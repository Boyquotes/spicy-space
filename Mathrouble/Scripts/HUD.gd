extends CanvasLayer

onready var score_lbl = $Game_HUD/Score_lbl
onready var wave_lbl = $Game_HUD/Wave_lbl
onready var gameover_hud = $GameOver_HUD
onready var highscore_lbl = $GameOver_HUD/HighScore_lbl
onready var bestwave_lbl = $GameOver_HUD/BestWave_lbl
onready var wave_hud = $Wave_HUD
onready var wave_start_lbl = $Wave_HUD/Wave_Start_lbl
onready var wave_completed_lbl = $Wave_HUD/Wave_Completed_lbl
onready var out_of_ammo_lbl = $Warning_HUD/Out_of_Ammo_lbl

var highscore = 0
var bestwave = 0

func _process(delta):
	update_values()

func update_values():
	score_lbl.text = "Score: " + str(Global.score)
	wave_lbl.text = "Wave: " + str(Global.wave)

func assign_playerdata(whichdata, value):
	if whichdata == "highscore":
		Global.save_highscore(value)
		highscore = str(Global.load_highscore()) # update high score
		highscore_lbl.text = "Highscore: " + highscore # assign high score to text
	if whichdata == "bestwave":
		Global.save_bestwave(value)
		bestwave = str(Global.load_bestwave())
		bestwave_lbl.text = "Best Wave: " + bestwave

func wave(con):
	if con == "started":
		wave_start_lbl.text = "Wave " + str(Global.wave + 1) + " Coming"
		wave_start_lbl.visible = true
		yield(get_tree().create_timer(3), "timeout")
		wave_start_lbl.visible = false
	if con == "completed":
		wave_completed_lbl.text = "Wave " + str(Global.wave) + " Completed"
		wave_completed_lbl.visible = true
		yield(get_tree().create_timer(3), "timeout")
		wave_completed_lbl.visible = false

func warning(type):
	if type == "out_of_ammo":
		out_of_ammo_lbl.visible = true
		yield(get_tree().create_timer(1), "timeout")
		out_of_ammo_lbl.visible = false

func game_over():
	gameover_hud.visible = true
	assign_playerdata("highscore", Global.score)
	assign_playerdata("bestwave", Global.wave)

func _on_Restart_btn_pressed():
	gameover_hud.visible = false
	Global.change_scene("Game")
