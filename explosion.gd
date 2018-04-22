extends AnimatedSprite

func _on_explosion_animation_finished():
	self.queue_free()
