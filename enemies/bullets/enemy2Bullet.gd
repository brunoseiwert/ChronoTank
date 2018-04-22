extends "res://bullet.gd"

var rebound = false

func _process(delta):
	self.look_at(self.global_position + vel)
	if !rebound:
		var pos = self.global_position
		if pos.x < 64 || pos.x > 2048 - 64:
			vel.x = -vel.x
			rebound = true
		elif pos.y < 64 || pos.y > 2048 - 64:
			vel.y = -vel.y
			rebound = true