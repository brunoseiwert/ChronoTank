extends KinematicBody2D

export(NodePath) var gamePath
export(PackedScene) var bullet

onready var tween = $"tween"
onready var game = get_node(gamePath)
onready var top = $"top"
onready var bulletSpawn = $"top/bulletSpawn"
onready var feet = $"feet"
onready var muzzleFlash = $"top/muzzleFlash"
onready var MFtimer = $"top/muzzleFlash/muzzleFlashTimer"

export(float) var movDur = 0.2
export(int) var bulletVel = 2000
export(int) var movRange = 500
export(AudioStream) var shootingSound
export(AudioStream) var deathSound
export(PackedScene) var explosion

var mov = Vector2()
var shoot = Vector2(1, 0)
var initPos = Vector2()

func _process(delta):
	if game.state == 1:
		if shoot != mov:
			feet.look_at(get_global_mouse_position())
			feet.rotation_degrees += 90
	elif game.state == 2:
		if shoot != mov:
			top.look_at(get_global_mouse_position())
			top.rotation_degrees += 90
	elif game.state == 3:
		if shoot != mov || shoot == Vector2():
			top.look_at(shoot)
			top.rotation_degrees += 90

func mov():
	checkMov()
	initPos = self.global_position
	tween.interpolate_property(self, "global_position", self.global_position, mov, movDur, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func shoot():
	game.audioPlayer.stream = shootingSound
	game.audioPlayer.play()
	if shoot != mov:
		top.look_at(shoot)
		top.rotation_degrees += 90
	
	var bul = bullet.instance()
	bul.global_position = bulletSpawn.global_position
	if shoot != mov:
		bul.vel = (shoot - self.global_position).normalized() * bulletVel
	else:
		bul.vel = (self.position - initPos).normalized() * bulletVel
	bul.look_at(shoot)
	#muzzle flash
	muzzleFlash.rotation_degrees = rand_range(0, 90)
	muzzleFlash.show()
	MFtimer.start()
	game.add_child(bul)
	
func checkMov():
	while mov.x < 96 || mov.x > 2048 - 96 || mov.y < 96 || mov.y > 2048 - 96:
		mov += (self.global_position - mov).normalized()

func die():
	var ex = explosion.instance()
	ex.global_position = self.global_position
	ex.play("explosion")
	game.add_child(ex)
	game.audioPlayer.stream = deathSound
	game.audioPlayer.play()
	game.gameOver()
	self.visible = false
	
func _on_tween_tween_completed(object, key):
	shoot()

func _on_muzzleFlashTimer_timeout():
	muzzleFlash.hide()
