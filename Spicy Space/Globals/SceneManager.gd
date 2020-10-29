extends Node

export (PackedScene) var transition

const SCENE_PATH = "res://Scenes/"

func change_scene(scene_name):
	show_transition()
	call_deferred("_deferred_change_scene", scene_name)
	if get_tree().paused == true: # if game paused
		get_tree().paused = false # unpaused 

func _deferred_change_scene(scene_name):
	yield(get_tree().create_timer(0.8), "timeout")
	var path = SCENE_PATH + scene_name + ".tscn"
	var root = get_tree().get_root()
	var current = root.get_child(root.get_child_count() - 1)
	current.free()
	var scene_resource = ResourceLoader.load(path)
	var new_scene = scene_resource.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)

func show_transition():
	var ins_transition = transition.instance()
	add_child(ins_transition)
	yield(get_tree().create_timer(1.6), "timeout")
	ins_transition.queue_free()


