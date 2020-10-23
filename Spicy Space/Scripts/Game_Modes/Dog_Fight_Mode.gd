extends "res://Scripts/Game_Modes/Mode.gd"

export (Array, PackedScene) var enemies
export (bool) var reset_userdata = false

#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Enemy
onready var enemy_con = $Pitfalls/Enemy/Enemy_Container
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Loot_Objects/Crate.tscn")

var ins_enemy # enemy instance
var mode_control = false #check out dog fight happened or not
var limit_for_enemy = 2
var enemy_counter = 0

#func _ready():
#	#get number of enemy
#	limit_for_enemy = UserDataManager.load_userdata("number_of_enemy")

func _process(delta):
	if mode_control:
		_dog_fight("checkout")

func _on_StartMode_Timer_timeout():
	yield(get_tree().create_timer(1), "timeout")
	hud.presentation("dog_fight", "started")
	yield(get_tree().create_timer(5), "timeout")
	_enemies("instance")

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
		#signal connect to drop crate after enemyship exploded
		ins_enemy.connect("enemyship_exploded", self, "drop_crate")
		#start dog fight
		_dog_fight("start")

func _dog_fight(con):
	if con == "start":
		spaceship.shoot_control = true
		while (enemy_counter < limit_for_enemy):
			_enemies("instance")
		mode_control = true #dog fight happen
	if con == "checkout":
		if mode_control && enemy_con.get_child_count() == 0:
			mode_control = false #dog fight over
			enemy_counter = 0 #reset enemy counter
			hud.presentation("dog_fight", "completed")
			spaceship.shoot_control = false
#			limit_for_enemy += 1 #increase number of enemies for next dog fight
			emit_signal("mode_completed", Global.game_mode.dog_fight)

func drop_crate(pos):
	var content_possibility = rand_range(0, 100)
	#drop crate
	if content_possibility < 50: 
		var ins_crate = crate.instance()
		crate_con.call_deferred("add_child", ins_crate) # !flushed_queries error fixed with this line
		ins_crate.position = pos
	#nothing
	else: 
		pass
