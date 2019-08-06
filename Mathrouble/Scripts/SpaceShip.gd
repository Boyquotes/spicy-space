extends Area2D

export var rot_speed = 2
export var thrust = 300
export var max_vel = 200
export var friction = 0.65

onready var laser = preload("res://Scenes/Laser.tscn")
onready var laser_container = $laser_container
onready var laser_muzzle = $laser_muzzle
onready var shoot_timer = $shoot_timer

var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()

func _ready():
	randomize()
	rot = rand_range(0, 90) #random rotation degree
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	self.position = pos
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("spaceship_shoot"):
		if shoot_timer.get_time_left() == 0:
			shoot()

	if Input.is_action_pressed("ui_up"):
		acc = Vector2(-thrust, 0).rotated(rot)
	elif Input.is_action_pressed("ui_down"):
		acc = Vector2(thrust, 0).rotated(rot)
	else:
		acc = Vector2(0, 0)

	if Input.is_action_pressed("ui_right"):
		rot += rot_speed * delta
	if Input.is_action_pressed("ui_left"):
		rot -= rot_speed * delta
	
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




