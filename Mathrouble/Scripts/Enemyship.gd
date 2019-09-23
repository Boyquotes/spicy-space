extends Area2D

export (float) var speed = 2.1

onready var es_sprite = $enemyship_sprite
onready var laser_muzzle1 = $laser_muzzle1
onready var laser_muzzle2 = $laser_muzzle2
onready var laser_con = $laser_container
onready var dir_timer = $direction_timer
onready var laser = preload("res://Scenes/Laser.tscn")

var vel = Vector2()
var dir
var screen_size
var extents
var target
var target_obj
var idle_control = false

func _ready():
	screen_size = get_viewport_rect().size
	extents = es_sprite.get_texture().get_size() / 2
	randomize()
	set_physics_process(true)
	#direction
	dir = rand_range(-25, 25)

func _physics_process(delta):
	_move_or_idle(delta)

	#target
	if target_obj == null:
		look_at(get_global_mouse_position())
	else:
		target = target_obj.global_position
		look_at(target)
	
	#for 90 degrees skew problem
	self.rotation_degrees += 90

	# wrap around screen edges
	var pos = self.position
	if pos.x > screen_size.x + extents.x:
		pos.x = -extents.x
	if pos.x < -extents.x:
		pos.x = screen_size.x + extents.x
	if pos.y > screen_size.y + extents.y:
		pos.y = -extents.y
	if pos.y < -extents.y:
		pos.y = screen_size.y + extents.y
	self.position = pos

func _change_dir():
		dir = rand_range(-25, 25)

func _move_or_idle(delta):
	if idle_control == false:
		vel.y -= 1
	else:
		vel.y = 0

	position += ((vel * delta).normalized() * speed).rotated(dir)

func _shoot():
	var laser_ins = laser.instance()
	var laser_ins2 = laser.instance()
	laser_con.add_child(laser_ins)
	laser_con.add_child(laser_ins2)
	laser_ins.start_at(self.rotation, laser_muzzle1.global_position, vel)
	laser_ins2.start_at(self.rotation, laser_muzzle2.global_position, vel)

func _on_direction_timer_timeout():
	_change_dir()
	dir_timer.wait_time = rand_range(1, 10)

func _on_idle_timer_timeout():
	var idle_or_move = rand_range(0,100)
	if idle_or_move > 50:
		idle_control = true
	else:
		idle_control = false

func _on_shoot_timer_timeout():
	_shoot()
