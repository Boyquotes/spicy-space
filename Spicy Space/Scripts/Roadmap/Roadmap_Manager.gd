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
	selected_roadmap.camera = get_parent().camera
	get_parent().camera.y_limit = selected_roadmap.scroll_limit
	add_child(selected_roadmap)

func open_roadmap():
	SceneManager.show_transition()
	yield(get_tree().create_timer(0.8), "timeout")
	get_parent().game.visible = false
	self.visible = true
	get_parent().ins_game_mode.call_deferred("free")
