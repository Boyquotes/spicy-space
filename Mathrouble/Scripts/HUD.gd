extends CanvasLayer

onready var score_lbl = $Game_HUD/Score_lbl
onready var gameover_hud = $GameOver_HUD
onready var highscore_lbl = $GameOver_HUD/HighScore_lbl

var highscore = 0
#var screen_center = Vector2()

func _ready():
#	screen_center = get_viewport().size / 2
#	gameover_lbl.rect_position = screen_center
	pass

func _process(delta):
	update_score()

func update_score():
	score_lbl.text = "Score: " + str(Global.score)

func assign_highscore(score):
	Global.save_highscore(score)
	highscore = str(Global.load_highscore()) # update high score
	highscore_lbl.text = "Highscore: " + highscore # assign high score to text

func game_over():
	gameover_hud.visible = true
	assign_highscore(Global.score)

func _on_Restart_btn_pressed():
	gameover_hud.visible = false
	Global.change_scene("Game")
