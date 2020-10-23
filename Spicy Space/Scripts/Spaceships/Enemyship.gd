extends Area2D

signal enemyship_exploded(pos)

export (float) var speed = 2.1
export (float) var health = 100
#export (float) var received_damage = 50
export (float) var shoot_time = 3

onready var es_sprite = $enemyship_sprite
onready var laser_muzzles = $laser_muzzles
onready var laser = preload("res://Scenes/Spaceship_,Parts/Lasers/EnemyLaser.tscn")
onready var laser_con = $laser_container
onready var dir_timer = $direction_timer
onready var shoot_timer = $shoot_timer
onready var health_bar = $HealthBar

var vel = Vector2()
var dir
var screen_size
var extents
var target
var target_obj
var idle_control = false
var damage_value = 0

func _ready():
	screen_size = get_viewport_rect().size
	extents = es_sprite.get_texture().get_size() / 2
	randomize()
	set_physics_process(true)
	#direction
	dir = rand_range(-25, 25)
	#health bar
#	health += (Global.wave * int(health / 10))
	health_bar.max_value = health
	health_bar.value = health_bar.max_value
	#shoot time
	shoot_timer.wait_time = shoot_time

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
	for lm in laser_muzzles.get_children():
		var laser_ins = laser.instance()
		laser_con.add_child(laser_ins)
		laser_ins.start_at(self.rotation, lm.global_position, vel)

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

func _on_CylonRaider_area_entered(area):
	if area.is_in_group("laser") || area.is_in_group("enemy_laser"):
		damage_value = area.laser_damage
		_get_damage(area, damage_value)
#	elif area.is_in_group("enemy_laser"): #friendly fire
#		damage_value = area.laser_damage
#		_get_damage(area, damage_value)

func _get_damage(area, damage_value):
	if health_bar.value > 0:
		health_bar.value -= damage_value #get damage
	elif health_bar.value <= 0:
		_explode()
	area.queue_free()

func _explode():
	emit_signal("enemyship_exploded", self.position)
	call_deferred("free")
	Global.score += 5 #increase score
