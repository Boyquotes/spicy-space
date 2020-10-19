extends "res://Scripts/Game_Modes/Game_Mode.gd"

export (PackedScene) var asteroid
export (PackedScene) var split_asteroid
export (int) var min_border_of_ast = 3
export (int) var max_border_of_ast = 5

#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Asteroid
onready var asteroid_timer = $Pitfalls/Asteroid/Asteroid_Timer
onready var asteroid_con = $Pitfalls/Asteroid/Asteroid_Container
#Mine
onready var mine_con = $Mine_Container
onready var mine = ResourceLoader.load("res://Scenes/Mine.tscn")

var ins_ast # asteroid instance
var ins_split_ast
var border_of_ast = 4 #border for asteroid instance
var number_of_ast = 1
var ast_counter = 0 #asteroid counter
var mode_control = false #check out to meteor shower
var ast_border_control = false #check out to asteroid border
var ast_split_pattern = {'big': 'med', 'med': null}

func _ready():
	#get number of asteroid
	if Global.wave < 25:
		number_of_ast = Global.wave
	else:
		number_of_ast = 25
	#assign a border of asteroid for first wave
	_asteroids("number_of_asteroid")

func _process(delta):
	if mode_control:
		_meteor_shower("checkout")

func _signal_connect(which_obj):
	if which_obj == "ast": #asteroid
		#signal to drop mine after asteroid exploded
		ins_ast.connect("ast_exploded", self, "drop_mine")
		#signal to split asteroid
		ins_ast.connect("ast_split", self, "ast_split")
	if which_obj == "split_ast":
		#signal to drop mine after asteroid exploded
		ins_split_ast.connect("ast_exploded", self, "drop_mine")
		#signal to split asteroid
		ins_split_ast.connect("ast_split", self, "ast_split")

func _on_StartMode_Timer_timeout():
	yield(get_tree().create_timer(1), "timeout")
	hud.presentation("meteor_shower", "started")
	yield(get_tree().create_timer(5), "timeout")
	_asteroids("start_timer")

func _on_Asteroid_Timer_timeout():
	spaceship.shoot_control = true
	asteroid_timer.wait_time = number_of_ast
	if ast_counter < border_of_ast:
		_asteroids("instance") #instance asteroid
		mode_control = true
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

func _meteor_shower(con):
	if con == "checkout":
		if mode_control && ast_border_control && asteroid_con.get_child_count() == 0:
			hud.presentation("meteor_shower", "completed")
			mode_control = false
			ast_border_control = false
			spaceship.shoot_control = false
			yield(get_tree().create_timer(15), "timeout")
			emit_signal("mode_completed")

func drop_mine(pos):
	var content_possibility = rand_range(0, 100)
	#drop mine
	if content_possibility < 50: 
		var ins_mine = mine.instance()
		mine_con.call_deferred("add_child", ins_mine) # !flushed_queries error fixed with this line
		ins_mine.position = pos
	#nothing
	else: 
		pass


