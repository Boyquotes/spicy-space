extends Node2D

func roadmap_handler(completed_mode):
	if completed_mode == Global.game_mode.start:
		_prepare_roadmap()
		open_roadmap()
	elif completed_mode == Global.game_mode.repairshop:
		open_roadmap()
	else:
		get_parent().game.spaceship_w_robots.cockpit_hud.roadmap_btn_state(true)

func _prepare_roadmap():
	var selected_roadmap = GameLogic.choosen_roadmap
	add_child(selected_roadmap)

func open_roadmap():
	get_parent().game.visible = false
	self.visible = true
	get_parent().ins_game_mode.call_deferred("free")
