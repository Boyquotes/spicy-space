extends TextureProgress

var rot_deg = self.rect_rotation

func _ready():
	set_physics_process(true)
	self.value = self.max_value

func _physics_process(delta):
	rotate_robot()

func rotate_robot():
	self.rect_rotation = rot_deg

func explode_robot():
	self.visible = false

func robot_charge(which_crate):
	if which_crate == "health_crate" && self.is_in_group("health_robot"):
		self.value += 10
#		print("health robot charged: " + str(self.value))
	if which_crate == "shield_crate" && self.is_in_group("shield_robot"):
		self.value += 5
		robot_color("white") #if it was red make it white because it charged again

func robot_color(which_color):
	if which_color == "red":
		self.modulate = Color(1, 0, 0) #change robots color as red
	if which_color == "white":
		self.modulate = Color(1, 1, 1) #change robots color as white