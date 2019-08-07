extends Node2D

export (PackedScene) var asteroid

onready var asteroid_spawn_loc = $Asteroid/Asteroid_Path/PathFollow2D
onready var asteroid_timer = $Asteroid/Asteroid_Timer
onready var asteroid_con = $Asteroid/Asteroid_Container

func _on_StartGame_Timer_timeout():
	asteroid_timer.start()

func _on_Asteroid_Timer_timeout():
    # Choose a random location on Path2D.
	asteroid_spawn_loc.set_offset(randi())
    # Create a asteroid instance and add it to the scene.
	var ast = asteroid.instance()
	asteroid_con.add_child(ast)
#   # Set the asteroid's position to a random location.
	ast.position = asteroid_spawn_loc.global_position

