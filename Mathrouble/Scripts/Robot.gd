extends TextureProgress

signal ss_explode #spaceship explode

var rot_deg = self.rect_rotation

func _ready():
	self.value = self.max_value

func _physics_process(delta):
	rotate_robot()

func damage_happened():
	if self.value > 0:
		self.value -= 10
	if self.value <= 0:
		emit_signal("ss_explode")

func rotate_robot():
	self.rect_rotation = rot_deg

func explode_robot():
	self.visible = false