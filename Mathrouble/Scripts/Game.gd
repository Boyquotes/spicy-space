extends Node2D

export (PackedScene) var asteroid
export (PackedScene) var enemy
export (bool) var reset_userdata = false
export (int) var min_border_of_ast = 7
export (int) var max_border_of_ast = 13

#Game
onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship = $SpaceShip
#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Asteroid
onready var asteroid_timer = $Pitfalls/Asteroid/Asteroid_Timer
onready var asteroid_con = $Pitfalls/Asteroid/Asteroid_Container
#Enemy
onready var enemy_con = $Pitfalls/Enemy/Enemy_Container
#HUD
onready var hud = $HUD
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/HealthRobot.tscn")
onready var ammo_robot = ResourceLoader.load("res://Scenes/AmmoRobot.tscn")
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Crate.tscn")
#Wave
onready var wave_sys = $Wave_System

var ins_hr # health robot instance
var ins_ar # ammo robot instance
var ins_ast # asteroid instance
var ins_enemy # enemy instance

var border_of_ast = 10 #border for asteroid instance
var ast_counter = 0 #asteroid counter
var wave_control = false #check out to waves
var border_control = false #check out to asteroid border
var df_control = false #check out dog fight happened or not

func _ready():
	#reset highscore
	if reset_userdata == true:
		Global.reset_highscore()
		Global.reset_bestwave()
	#reset score after every new start
	Global.score = 0
	#reset wave after every new start
	Global.wave = 0
	#assign a border of asteroid for first wave
	randomize()
	border_of_ast = rand_range(min_border_of_ast, max_border_of_ast)
	print(border_of_ast)
	
	_robots_activate()
	_signal_connect("ss")

func _process(delta):
	if wave_control:
		_wave("checkout")
	if df_control:
		_dog_fight("checkout")

func _robots_activate():
	#create follow ai for robots
	var hr_follow_ai = follow_ai.instance()
	var ar_follow_ai = follow_ai.instance()
	add_child(hr_follow_ai)
	add_child(ar_follow_ai)
	hr_follow_ai.global_position = Vector2(spaceship.global_position.x - 15, spaceship.global_position.y - 35)
	ar_follow_ai.global_position = Vector2(spaceship.global_position.x + 5, spaceship.global_position.y - 35)

	#create health robot
	ins_hr = health_robot.instance()
	hr_follow_ai.add_child(ins_hr)
	#set location for hr to folllow spaceship
	hr_follow_ai.following_obj = spaceship.hr_followpoint
	hr_follow_ai.target = spaceship.hr_followpoint.global_position

	#create ammo robot
	ins_ar = ammo_robot.instance()
	ar_follow_ai.add_child(ins_ar)
	#set location for ar to folllow spaceship
	ar_follow_ai.following_obj = spaceship.ar_followpoint
	ar_follow_ai.target = spaceship.ar_followpoint.global_position
	
	# add robots to the spaceship
	spaceship.robots.append(ins_hr)
	spaceship.robots.append(ins_ar)
	
	_signal_connect("hr")
	_signal_connect("ar")

func _signal_connect(which_obj):
	if which_obj == "ss": #space ship
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#when spaceship grabbed crate signal connect
		spaceship.connect("crate_grabbed", ins_hr, "robot_charge")
		spaceship.connect("crate_grabbed", ins_ar, "robot_charge")
		#warning signal
		spaceship.connect("warning", hud, "warning")
		#screen shake signal connect
		spaceship.connect("ss_damage", self, "screen_shake")
	if which_obj == "hr": #health robot
		#spaceship damage signal connect
		spaceship.connect("ss_damage", ins_hr, "damage_happened")
		#spaceship explode signal connect
		ins_hr.connect("ss_explode", spaceship, "ss_explode")
	if which_obj == "ar": #ammo robot
		#reduce ammo when laser shooted signal connect
		spaceship.connect("shoot", ins_ar, "laser_shooted")
		#check out ammo signal connect
		ins_ar.connect("out_of_ammo", spaceship, "out_of_ammo_control")
	if which_obj == "ast": #asteroid
		#signal to crate control after asteroid exploded
		ins_ast.connect("ast_exploded", self, "crate_control")

func _on_StartGame_Timer_timeout():
	yield(get_tree().create_timer(1), "timeout")
	hud.presentation("wave", "started")
	yield(get_tree().create_timer(5), "timeout")
	_asteroids("start_timer")

func _on_Asteroid_Timer_timeout():
	if ast_counter < border_of_ast:
		_asteroids("instance") #instance asteroid
		wave_control = true
	else:
		border_control = true
		ast_counter = 0 # reset asteroid counter
		_asteroids("stop_timer")
#	print(ast_counter)

func _asteroids(con):
	if con == "start_timer":
		asteroid_timer.start()
		wave_sys.inc_wave()
	if con == "stop_timer":
		asteroid_timer.stop()
	if con == "instance":
		# Choose a random location on Path2D.
		pitfalls_spawn_loc.set_offset(randi())
	    # Create a asteroid instance and add it to the scene.
		ins_ast = asteroid.instance()
		asteroid_con.add_child(ins_ast)
		ast_counter += 1 #increase asteroid counter
	    # Set the asteroid's position to a random location.
		ins_ast.position = pitfalls_spawn_loc.global_position
		#signal connect
		_signal_connect("ast")

func _enemies(con):
	if con == "instance":
		# Choose a random location on Path2D.
		pitfalls_spawn_loc.set_offset(randi())
	    # Create a enemy instance and add it to the scene.
		ins_enemy = enemy.instance()
		enemy_con.add_child(ins_enemy)
	    # Set the asteroid's position to a random location.
		ins_enemy.position = pitfalls_spawn_loc.global_position
		#assign spaceship as target
		ins_enemy.target_obj = spaceship

func _wave(con):
	if con == "checkout":
		if wave_control && border_control && asteroid_con.get_child_count() == 0:
			hud.presentation("wave", "completed")
			wave_control = false
			border_control = false
			yield(get_tree().create_timer(5), "timeout")
            #dog fight or new wave
			_dog_fight("possibility")
	if con == "new_wave":
		hud.presentation("wave", "started")
		randomize()
		border_of_ast += rand_range(min_border_of_ast, max_border_of_ast) #increase number of ast after every new wave
		print(border_of_ast)
		yield(get_tree().create_timer(5), "timeout")
		_asteroids("start_timer")
		_asteroids("instance")

func _dog_fight(con):
	if con == "possibility":
		randomize()
		var df_possibility = rand_range(0, 100) #dog fight's gonna happen or not ?
#		print(df_possibility)
		if df_possibility < 90:
			hud.presentation("dog_fight", "started")
			_enemies("instance")
			df_control = true #dog fight happen
		else:
			df_control = false #dog fight doesn't happen
			_wave("new_wave")
	if con == "checkout":
		if df_control && enemy_con.get_child_count() == 0:
			df_control = false
			hud.presentation("dog_fight", "completed")
			yield(get_tree().create_timer(5), "timeout")
			_wave("new_wave")

func crate_control(pos):
	var crate_chance = rand_range(0, 100)
	if crate_chance < 25:
		var ins_crate = crate.instance()
		crate_con.call_deferred("add_child", ins_crate) # !flushed_queries error fixed with this line
		ins_crate.position = pos
	#	print(pos)
	else:
		pass

func screen_shake():
	screen_shake.start(0.2, 15, 16, 1)

func game_over():
	hud.game_over()

