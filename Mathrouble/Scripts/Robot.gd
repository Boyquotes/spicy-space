extends TextureProgress

var rot_deg = self.rect_rotation

func _ready():
	self.value = self.max_value

func _physics_process(delta):
	rotate_robot()

func rotate_robot():
	self.rect_rotation = rot_deg

func explode_robot():
	self.visible = false