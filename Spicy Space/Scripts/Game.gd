extends Node2D

export (PackedScene) var asteroid
export (PackedScene) var split_asteroid
export (Array, PackedScene) var enemies
export (bool) var reset_userdata = false
export (int) var min_border_of_ast = 3
export (int) var max_border_of_ast = 5

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
#Uograde HUD
onready var upg_hud = $HUD/Upgrade_HUD
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/Robots/HealthRobot.tscn")
#onready var ammo_robot = ResourceLoader.load("res://Scenes/Robots/AmmoRobot.tscn")
onready var shield_robot = ResourceLoader.load("res://Scenes/Robots/ShieldRobot.tscn")
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Crate.tscn")
#Mine
onready var mine_con = $Mine_Container
onready var mine = ResourceLoader.load("res://Scenes/Mine.tscn")

var ins_hr # health robot instance
var ins_ar # ammo robot instance
var ins_sr # shield robot instance
var ins_ast # asteroid instance
var ins_split_ast
var ins_enemy # enemy instance

var border_of_ast = 4 #border for asteroid instance
var number_of_ast = 1
var ast_counter = 0 #asteroid counter
var wave_control = false #check out to waves
var ast_border_control = false #check out to asteroid border
var df_control = false #check out dog fight happened or not
var border_of_enemy = 1
var enemy_counter = 0
var ast_split_pattern = {'big': 'med', 'med': null}

func _ready():
	#reset highscore
	if reset_userdata == true:
		UserDataManager.reset_userdata()
	#reset score after every new start
	Global.score = 0
	#reset wave after every new start
#	Global.wave = 0
	#get number of asteroid
	if Global.wave < 25:
		number_of_ast = Global.wave
	else:
		number_of_ast = 25
	#assign a border of asteroid for first wave
	_asteroids("number_of_asteroid")
	#assign the border of asteroid to wave bar's max value
	hud.wave_bar_max_value = int(border_of_ast * number_of_ast)
	hud.wave_bar("wave_up")
	#get number of enemy
	border_of_enemy = UserDataManager.load_userdata("number_of_enemy")
	
	_robots_activate()
	_signal_connect("ss")
	_signal_connect("upg_sys")

func _process(delta):
	if wave_control:
		_wave("checkout")
	if df_control:
		_dog_fight("checkout")

	#automatic shoot system for spaceship
	if wave_control || df_control:
		_ss_shoot_system(true)
	else:
		_ss_shoot_system(false)

func _robots_activate():
	#create follow ai for robots
	var hr_follow_ai = follow_ai.instance()
	var sr_follow_ai = follow_ai.instance()
	add_child(hr_follow_ai)
	add_child(sr_follow_ai)
	hr_follow_ai.global_position = Vector2(spaceship.global_position.x - 15, spaceship.global_position.y - 35)
	sr_follow_ai.global_position = Vector2(spaceship.global_position.x + 5, spaceship.global_position.y - 35)

	#create health robot
	ins_hr = health_robot.instance()
	hr_follow_ai.add_child(ins_hr)
	#set location for hr to folllow spaceship
	hr_follow_ai.following_obj = spaceship.hr_followpoint
	hr_follow_ai.target = spaceship.hr_followpoint.global_position

	#create shield robot
	ins_sr = shield_robot.instance()
	sr_follow_ai.add_child(ins_sr)
	#set location for sr to follow spaceship
	sr_follow_ai.following_obj = spaceship.sr_followpoint
	sr_follow_ai.target = spaceship.sr_followpoint.global_position
	
	# add robots to the spaceship
	spaceship.robots.append(ins_hr)
	spaceship.robots.append(ins_sr)
	
	_signal_connect("hr")
	_signal_connect("sr")

func _signal_connect(which_obj):
	if which_obj == "ss": #space ship
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#when spaceship grabbed crate signal connect
		spaceship.connect("crate_grabbed", ins_hr, "robot_charge")
		spaceship.connect("crate_grabbed", ins_sr, "robot_charge")
		#warning signal
		spaceship.connect("warning", hud, "warning")
		#screen shake signal connect
		spaceship.connect("ss_damage", self, "screen_shake")
		#health robot situation signal control
		spaceship.connect("hr_situation", ins_hr, "hr_situation")
		#when spaceship grabbed mine signal connect
		spaceship.connect("mine_grabbed", self, "mine_system")
	if which_obj == "hr": #health robot
		#spaceship damage signal connect
		spaceship.connect("ss_damage", ins_hr, "damage_happened")
		#spaceship explode signal connect
		ins_hr.connect("ss_explode", spaceship, "ss_explode")
	if which_obj == "sr": #shield robot
		#spaceship damage signal connect
		spaceship.connect("ss_damage", ins_sr, "damage_happened")
		#change health robot situation according to shield robot situation signal connect
		ins_sr.connect("sr_deactivated", ins_hr, "hr_situation")
		#change shield situation according to shield robot situation signal connect
		ins_sr.connect("sr_deactivated", spaceship, "ss_shield_deactivate")
	if which_obj == "ast": #asteroid
		#signal to crate control after asteroid exploded
		ins_ast.connect("ast_exploded", self, "ast_content_control")
		#signal to split asteroid signal control
		ins_ast.connect("ast_split", self, "ast_split")
	if which_obj == "split_ast":
		#signal to crate control after asteroid exploded
		ins_split_ast.connect("ast_exploded", self, "ast_content_control")
		#signal to split asteroid signal control
		ins_split_ast.connect("ast_split", self, "ast_split")
	if which_obj == "upg_sys":
		#signal to update mine after spend or collect it
		upg_hud.connect("mine_spend", self, "mine_system")
		#signal to upgrade ship part
		upg_hud.connect("upgraded", self, "upgrade_system")

func _on_StartGame_Timer_timeout():
	yield(get_tree().create_timer(1), "timeout")
	hud.presentation("wave", "started")
	yield(get_tree().create_timer(5), "timeout")
	_asteroids("start_timer")

func _on_Asteroid_Timer_timeout():
	asteroid_timer.wait_time = number_of_ast
	if ast_counter < border_of_ast:
		_asteroids("instance") #instance asteroid
		wave_control = true
	else:
		ast_border_control = true
		ast_counter = 0 # reset asteroid counter
		_asteroids("stop_timer")
#	print(ast_counter)

func _asteroids(con):
	if con == "start_timer":
		asteroid_timer.start()
		hud.wave_bar("wave_up")
	if con == "stop_timer":
		asteroid_timer.stop()
	if con == "instance":
		if Global.wave < 25:
			number_of_ast = Global.wave
		else:
			number_of_ast = 25
		#instance wave asteroids
		for i in range(number_of_ast):
			# Choose a random location on Path2D.
			pitfalls_spawn_loc.set_offset(randi())
			# Create a asteroid instance and add it to the scene.
			ins_ast = asteroid.instance()
			asteroid_con.add_child(ins_ast)
			#fill wave bar after every asteroid instance
			hud.wave_bar("fill_bar")
			# Set the asteroid's position to a random location.
			ins_ast.position = pitfalls_spawn_loc.global_position
			#signal connect
			_signal_connect("ast")
		#increase asteroid counter
		ast_counter += 1
	if con == "number_of_asteroid":
		randomize()
		border_of_ast = rand_range(min_border_of_ast, max_border_of_ast)
#		print("number of asteroid: " + str(int(border_of_ast)))

func ast_split(ast_size, ast_scale, pos, vel, hit_vel):
	var newsize = ast_split_pattern[ast_size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(25) * offset
			var newvel = vel + hit_vel.tangent() * offset
			spawn_split_ast(newsize, ast_scale, newpos, newvel)

func spawn_split_ast(ast_size, ast_scale, pos, vel):
	ins_split_ast = split_asteroid.instance()
	asteroid_con.call_deferred("add_child", ins_split_ast)
	ins_split_ast.init(ast_size, ast_scale, pos, vel)
	_signal_connect("split_ast")

func _enemies(con):
	if con == "instance":
		# Choose a random location on Path2D.
		pitfalls_spawn_loc.set_offset(randi())
		# Create a enemy instance and add it to the scene.
		ins_enemy = enemies[randi() % enemies.size()].instance() #choose an enemy and instance it
		enemy_con.add_child(ins_enemy)
		enemy_counter += 1
		# Set the asteroid's position to a random location.
		ins_enemy.position = pitfalls_spawn_loc.global_position
		#assign spaceship as target
		ins_enemy.target_obj = spaceship

func _wave(con):
	if con == "checkout":
		if wave_control && ast_border_control && asteroid_con.get_child_count() == 0:
			hud.presentation("wave", "completed")
			wave_control = false
			ast_border_control = false
			#increase wave value and save it
			Global.wave += 1
			UserDataManager.save_userdata("current_wave", int(Global.wave))
			yield(get_tree().create_timer(5), "timeout")
			#dog fight or new wave
			_dog_fight("possibility")

	if con == "new_wave":
		hud.presentation("wave", "started")
		randomize()
#		border_of_ast += randi()%Global.wave+1 #increase number of ast after every new wave
		_asteroids("number_of_asteroid")
		#assign the border of asteroid to wave bar's max value
		hud.wave_bar_max_value = int(border_of_ast * number_of_ast)
		hud.wave_bar("wave_up")
		yield(get_tree().create_timer(5), "timeout")
		_asteroids("start_timer")
		_asteroids("instance")

func _dog_fight(con):
	if con == "possibility":
		randomize()
		var df_possibility = rand_range(0, 100) #dog fight's gonna happen or not ?
#		print(df_possibility)
		if df_possibility < 70:
			hud.presentation("dog_fight", "started")
			while (enemy_counter < border_of_enemy):
				_enemies("instance")
			df_control = true #dog fight happen
		else:
			df_control = false #dog fight doesn't happen
			_wave("new_wave")

	if con == "checkout":
		if df_control && enemy_con.get_child_count() == 0:
			df_control = false #dog fight over
			enemy_counter = 0 #reset enemy counter
			
			randomize()
			var noe_possibility = rand_range(0, 90) #number of enemy possibility
#			print(noe_possibility)
			if noe_possibility <= 45:
				border_of_enemy += 1 #increase enemy number for present dog fight
			elif noe_possibility > 45 && noe_possibility <= 75:
				border_of_enemy += 0 #don't change enemy number for present dog fight
			elif noe_possibility > 75:
				if border_of_enemy > 3: #when number of enemy at least 4
					border_of_enemy -= 1 #reduce enemy number for present dog fight
				else:
					border_of_enemy -= 0 #don't change enemy number for present dog fight
#			print(border_of_enemy)
			UserDataManager.save_userdata("number_of_enemy", border_of_enemy)

			hud.presentation("dog_fight", "completed")
			yield(get_tree().create_timer(5), "timeout")
			_wave("new_wave")

func ast_content_control(pos):
	var content_possibility = rand_range(0, 100)
	#crate
	if content_possibility <= 15: 
		var ins_crate = crate.instance()
		crate_con.call_deferred("add_child", ins_crate) # !flushed_queries error fixed with this line
		ins_crate.position = pos
	#mine
	elif content_possibility > 15 && content_possibility < 50: 
		var ins_mine = mine.instance()
		mine_con.call_deferred("add_child", ins_mine) # !flushed_queries error fixed with this line
		ins_mine.position = pos
	#nothing
	else: 
		pass

func mine_system(con):
	if con == "collect":
		var collected_mine = int(rand_range(Global.wave * 2, Global.wave * 3))
#		print(collected_mine)
		Global.mine_counter += collected_mine
	if con == "spend":
		pass
	if con == "game_over":
		Global.mine_counter -= int(Global.mine_counter * 0.3)
	#save and show mine value
	UserDataManager.save_userdata("mine", Global.mine_counter)
	hud.show_mine_value()

func upgrade_system(part):
	if part == "ship_dur":
		ins_hr.reload_robot(part)
	if part == "shield":
		ins_sr.reload_robot(part)
	if part == "shoot_rate":
		spaceship.reload_spaceship()
#	if part == "laser_damage":
#		spaceship.prepare_laser()

func _ss_shoot_system(con): #spaceship shoot system
	spaceship.shoot_control = con

func screen_shake(which_pitfall):
	screen_shake.start(0.2, 15, 16, 1)

func game_over():
	Global.fail_counter += 1
	mine_system("game_over")
	hud.game_over()

