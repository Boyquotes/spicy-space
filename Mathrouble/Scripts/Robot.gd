extends TextureProgress

signal ss_explode #spaceship explode

func _ready():
	self.value = self.max_value

func damage_happened():
	if self.value > 0:
		self.value -= 10
	if self.value <= 0:
		emit_signal("ss_explode")
		_explode_robot() # health robot explode too

func _explode_robot():
	self.visible = false