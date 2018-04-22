extends "res://enemies/enemy.gd"

export(int) var spread = 10

func shoot():
	for i in [-1, 0, 1]:
		var bul = bullet.instance()
		bul.global_position = bulletSpawn.global_position
		var angle = i * spread * PI / 180
		var vel = (shoot - self.global_position).normalized()
		bul.vel = Vector2(vel.x * cos(angle) - vel.y * sin(angle), vel.x * sin(angle) + vel.y * cos(angle)) * bulletVel
		bul.look_at(bul.global_position + bul.vel)
		top.look_at(self.global_position + bul.vel)
		top.rotation_degrees += 90
		game.add_child(bul)
	#muzzle flash
	muzzleFlash.rotation_degrees = rand_range(0, 90)
	muzzleFlash.show()
	MFtimer.start()

func _on_muzzleFlashTimer_timeout():
	muzzleFlash.hide()
