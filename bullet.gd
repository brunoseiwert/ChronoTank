extends Area2D

var vel = Vector2()
var targetGroup = ""

func _ready():
	if vel == Vector2():
		queue_free()
	if self.is_in_group("friendly"):
		targetGroup = "enemy"
	else:
		targetGroup = "friendly"

func _process(delta):
	self.global_position += vel * delta
	#check if far away from screen to delete it
	var pos = self.global_position
	if pos.x > 5000 || pos.x < -5000 || pos.y < -5000 || pos.y > 5000:
		queue_free()

func _on_bullet_body_entered(body):
	if body.is_in_group(targetGroup):
		body.die()
		hit()

func hit():
	
	self.queue_free()