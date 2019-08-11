extends Area2D

signal ss_damage
signal game_over

export var rot_speed = 2
export var thrust = 300
#export var max_vel = 200
export var friction = 0.65

onready var laser = preload("res://Scenes/Laser.tscn")
onready var laser_container = $laser_container
onready var laser_muzzle = $laser_muzzle
onready var shoot_timer = $shoot_timer
onready var hr_followpoint = $HR_FollowPoint # Health robot follow point
onready var ar_followpoint = $AR_FollowPoint # Ammo robot follow point

var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()
var explode_control = false

func _ready():
	randomize()
	rot = rand_range(0, 90) #random rotation degree
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	self.position = pos
	set_process(true)
#	prog_follow.following_obj = self
	explode_control = false
	
func _process(delta):
	if explode_control == false: # if ss exploded
		_ss_move(delta)
	_stay_on_screen(delta) 

func _ss_move(delta):
	if Input.is_action_pressed("ui_down"):
		if shoot_timer.get_time_left() == 0 and explode_control == false:
			shoot()

	if Input.is_action_pressed("ui_up"):
		acc = Vector2(-thrust, 0).rotated(rot)
#		print("ship move")
#	elif Input.is_action_pressed("ui_down"):
#		acc = Vector2(thrust, 0).rotated(rot)
##		print("ship move")
	else:
		acc = Vector2(0, 0)
#		print("ship stopped")

	if Input.is_action_pressed("ui_right"):
		rot += rot_speed * delta
#		print("ship move")
	if Input.is_action_pressed("ui_left"):
		rot -= rot_speed * delta
#		print("ship move")

func _stay_on_screen(delta):
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	if pos.x > screen_size.x:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.y
	self.position = pos
		
	self.rotation = rot - PI/2

func shoot():
	shoot_timer.start()
	var laser_ins = laser.instance()
	laser_container.add_child(laser_ins)
	laser_ins.start_at(self.rotation, laser_muzzle.global_position, vel)

func _on_SpaceShip_body_entered(body): #when any collide happen
	emit_signal("ss_damage")
	if body.is_in_group("asteroid"): # when asteroid hit spaceship
		body.explode()

func ss_explode():
	explode_control = true
	self.visible = false
	self.call_deferred("set_monitoring", false)
	emit_signal("game_over")