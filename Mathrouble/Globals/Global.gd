extends Node

#GAME VALUES
var score = 0
var wave = 0

#SCENE MANAGER
const SCENE_PATH = "res://Scenes/"

func change_scene(scene_name):
	yield(get_tree().create_timer(0.65), "timeout")
	call_deferred("_deferred_change_scene", scene_name)
	if get_tree().paused == true: # if game paused
		get_tree().paused = false # unpaused 

func _deferred_change_scene(scene_name):
	var path = SCENE_PATH + scene_name + ".tscn"
	var root = get_tree().get_root()
	var current = root.get_child(root.get_child_count() - 1)
	current.free()
	var scene_resource = ResourceLoader.load(path)
	var new_scene = scene_resource.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)

#HIGHSCORE
const SAVE_HS_FILE_PATH = "user://highscore.save"

func save_highscore(score):
	if load_highscore() > score:
		return
	
	var save_file = File.new()
	save_file.open(SAVE_HS_FILE_PATH, File.WRITE)
	var hs_data = {
		highscore = score
	}
	save_file.store_line(to_json(hs_data))
	save_file.close()

func load_highscore():
	var save_file = File.new()
	if !save_file.file_exists(SAVE_HS_FILE_PATH):
		return 0
		
	var highscore
	
	save_file.open(SAVE_HS_FILE_PATH, File.READ)
	var hs_data  = parse_json(save_file.get_line())
	return hs_data["highscore"]

func reset_highscore():
	var dir = Directory.new()
	dir.remove(SAVE_HS_FILE_PATH)

#BEST WAVE
const SAVE_BW_FILE_PATH = "user://bestwave.save"

func save_bestwave(wave):
	if load_bestwave() > wave:
		return
	
	var save_file = File.new()
	save_file.open(SAVE_BW_FILE_PATH, File.WRITE)
	var bw_data = {
		bestwave = wave
	}
	save_file.store_line(to_json(bw_data))
	save_file.close()

func load_bestwave():
	var save_file = File.new()
	if !save_file.file_exists(SAVE_BW_FILE_PATH):
		return 0
		
	var bestwave
	
	save_file.open(SAVE_BW_FILE_PATH, File.READ)
	var bw_data  = parse_json(save_file.get_line())
	return bw_data["bestwave"]

func reset_bestwave():
	var dir = Directory.new()
	dir.remove(SAVE_BW_FILE_PATH)