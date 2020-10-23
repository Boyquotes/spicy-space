extends TextureProgress

var damage_value = 1
var rot_deg = self.rect_rotation

func _ready():
	set_physics_process(true)
	self.value = self.max_value

func _physics_process(delta):
	rotate_robot()

func reload_robot(upgraded_part):
	self.max_value = Global.ship_datas.get(upgraded_part)
	self.value = self.max_value

func damage_happened(value):
	pass

func _get_damage(damage_value):
	pass

func rotate_robot():
	self.rect_rotation = rot_deg

func explode_robot():
	self.visible = false

#does robot need charge or not?
func robot_charge_control():
	if self.value == self.max_value:
		return false
	return true

func robot_charge(which_crate):
	if which_crate == "health_crate" && self.is_in_group("health_robot"):
		self.value += self.max_value / 10
#		print("health robot charged: " + str(self.value))
	if which_crate == "shield_crate" && self.is_in_group("shield_robot"):
		self.value += self.max_value / 5
		robot_color("white") #if it was red make it white because it charged again

func robot_color(which_color):
	if which_color == "red":
		self.modulate = Color(0.8, 0.3, 0.3) #change robots color as red
	if which_color == "white":
		self.modulate = Color(1, 1, 1) #change robots color as white
