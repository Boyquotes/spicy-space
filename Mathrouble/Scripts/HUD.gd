extends CanvasLayer

#Game HUD
onready var score_lbl = $Game_HUD/Score_lbl
onready var wave_lbl = $Game_HUD/Wave_lbl
onready var mine_lbl = $Game_HUD/Mine_lbl
onready var wave_bar = $Game_HUD/WaveBar
onready var current_wave_text = $Game_HUD/WaveBar/Current_Wave_Lvl/wave_lvl_sprite/wave_lvl_text
onready var next_wave_text = $Game_HUD/WaveBar/Next_Wave_Lvl/wave_lvl_sprite/wave_lvl_text
#Game Over HUD
onready var gameover_hud = $GameOver_HUD
onready var highscore_lbl = $GameOver_HUD/HighScore_lbl
onready var bestwave_lbl = $GameOver_HUD/BestWave_lbl
#Wave HUD
onready var wave_hud = $Wave_HUD
onready var wave_start_lbl = $Wave_HUD/Wave_Start_lbl
onready var wave_completed_lbl = $Wave_HUD/Wave_Completed_lbl
#Dog Fight HUD
onready var df_start_lbl = $DogFight_HUD/DF_Start_lbl
onready var df_over_lbl = $DogFight_HUD/DF_Over_lbl
#Warning HUD
onready var out_of_ammo_lbl = $Warning_HUD/Out_of_Ammo_lbl

var highscore = 0
var bestwave = 0
var mine_counter = 0
var wave_bar_max_value = 100

func _ready():
	wave_bar("start")

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

func presentation(action, con):
	if con == "started":
		if action == "wave":
			wave_start_lbl.text = "Wave " + str(Global.wave + 1) + " Coming"
			wave_start_lbl.visible = true
			yield(get_tree().create_timer(3), "timeout")
			wave_start_lbl.visible = false
		if action == "dog_fight":
			df_start_lbl.visible = true
			yield(get_tree().create_timer(3), "timeout")
			df_start_lbl.visible = false
	if con == "completed":
		if action == "wave":
			wave_completed_lbl.text = "Wave " + str(Global.wave) + " Completed"
			wave_completed_lbl.visible = true
			yield(get_tree().create_timer(3), "timeout")
			wave_completed_lbl.visible = false
		if action == "dog_fight":
			df_over_lbl.visible = true
			yield(get_tree().create_timer(3), "timeout")
			df_over_lbl.visible = false

func wave_bar(con):
	if con == "start":
		wave_bar.value = 0
		wave_bar.min_value = 0
		wave_bar.max_value = wave_bar_max_value
#	if con == "update":
#		wave_bar.max_value = wave_bar_max_value
	if con == "fill_bar":
		if wave_bar.value < wave_bar.max_value:
			wave_bar.value += 1
	if con == "wave_up":
			wave_bar.max_value = wave_bar_max_value
			current_wave_text.text = str(Global.wave)
			next_wave_text.text = str(Global.wave + 1)
			wave_bar.value = 0

func mine_collect():
	mine_counter += 1
	mine_lbl.text = "x " + str(mine_counter)

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
