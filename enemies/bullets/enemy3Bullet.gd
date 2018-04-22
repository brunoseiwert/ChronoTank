extends "res://bullet.gd"

onready var game = $"/root/Game"

export(PackedScene) var newBul

func _process(delta):
		var pos = self.global_position
		if pos.x < 64 || pos.x > 2048 - 64:
			hit()
		elif pos.y < 64 || pos.y > 2048 - 64:
			hit()
			
func hit():
	var speed = vel.length()
	
	for i in [45, 90, 135, 180, 225, 270, 315, 360]:
		var bul = newBul.instance()
		
		var newPos = self.global_position
		newPos.x = clamp(newPos.x, 65, 2048 - 65)
		newPos.y = clamp(newPos.y, 65, 2048 - 65)
		bul.global_position = newPos
		bul.vel = Vector2(sin(i * PI / 180), cos(i * PI / 180)) * speed
		bul.look_at(bul.global_position + bul.vel)
		game.add_child(bul)
		
	.hit()