extends KinematicBody2D

export(PackedScene) var bullet

onready var tween = $"tween"
onready var game = get_node("/root/Game")
onready var top = $"top"
onready var bulletSpawn = $"top/bulletSpawn"
onready var feet = $"feet"
onready var muzzleFlash = $"top/muzzleFlash"
onready var MFtimer = $"top/muzzleFlash/muzzleFlashTimer"

export(float) var movDur = 0.2
export(int) var bulletVel = 2000
export(int) var movRange = 200
export(int) var bulletSpread = 154
export(AudioStream) var deathSound
export(PackedScene) var explosion

var mov = Vector2()
var shoot = Vector2()

func mov():
	checkMov()
	feet.look_at(mov)
	feet.rotation_degrees += 90
	tween.interpolate_property(self, "global_position", self.global_position, mov, movDur, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()

func shoot():
	var bul = bullet.instance()
	bul.global_position = bulletSpawn.global_position
	var angle = rand_range(-bulletSpread, bulletSpread) * PI / 180
	var vel = (shoot - self.global_position).normalized()
	bul.vel = Vector2(vel.x * cos(angle) - vel.y * sin(angle), vel.x * sin(angle) + vel.y * cos(angle)) * bulletVel
	bul.look_at(bul.global_position + bul.vel)
	top.look_at(self.global_position + bul.vel)
	top.rotation_degrees += 90
	#muzzle flash
	muzzleFlash.rotation_degrees = rand_range(0, 90)
	muzzleFlash.show()
	MFtimer.start()
	game.add_child(bul)
	
func checkMov():
	print(mov)
	while mov.x < 96 || mov.x > 2048 - 96 || mov.y < 96 || mov.y > 2048 - 96:
		mov += (self.global_position - mov).normalized()
		
func die():
	var ex = explosion.instance()
	ex.global_position = self.global_position
	ex.play("explosion")
	game.add_child(ex)
	game.audioPlayer.stream = deathSound
	game.audioPlayer.play()
	game.currLevel.enemyCount -= 1
	if game.currLevel.enemyCount <= 0:
		game.levelUp()
	queue_free()

func _on_tween_tween_completed(object, key):
	shoot()

func _on_muzzleFlashTimer_timeout():
	muzzleFlash.hide()
