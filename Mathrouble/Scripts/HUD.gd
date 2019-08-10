extends CanvasLayer

onready var gameover_lbl = $GameOver_lbl

#var screen_center = Vector2()

func _ready():
#	screen_center = get_viewport().size / 2
#	gameover_lbl.rect_position = screen_center
	pass

func game_over():
	gameover_lbl.visible = true