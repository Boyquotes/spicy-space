extends Node2D

export (PackedScene) var asteroid
export (bool) var reset_highscore = false

onready var spaceship = $SpaceShip
#Asteroid
onready var asteroid_spawn_loc = $Asteroid/Asteroid_Path/PathFollow2D
onready var asteroid_timer = $Asteroid/Asteroid_Timer
onready var asteroid_con = $Asteroid/Asteroid_Container
#ProgressFollow
onready var prog_follow = $ProgressFollow
onready var health_robot = $ProgressFollow/HealthRobot
#HUD
onready var hud = $HUD

func _ready():
	#reset highscore
	if reset_highscore == true:
		Global.reset_highscore()
	#set location to folllow spaceship
	prog_follow.following_obj = spaceship.followpoint
	prog_follow.target = spaceship.followpoint.global_position
	signal_connect()

func signal_connect():
	#spaceship damage signal connect
	spaceship.connect("ss_damage", health_robot, "damage_happened")
	#spaceship explode signal connect
	health_robot.connect("ss_explode", spaceship, "ss_explode")
	# game over signal connect
	spaceship.connect("game_over", self, "game_over")

func _on_StartGame_Timer_timeout():
	asteroid_timer.start()

func _on_Asteroid_Timer_timeout():
    # Choose a random location on Path2D.
	asteroid_spawn_loc.set_offset(randi())
    # Create a asteroid instance and add it to the scene.
	var ast = asteroid.instance()
	asteroid_con.add_child(ast)
    # Set the asteroid's position to a random location.
	ast.position = asteroid_spawn_loc.global_position

func game_over():
	hud.game_over()

