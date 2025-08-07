extends RigidBody2D

var id:int

func set_object(new_id:int, object_sprite:int, speed:float, new_direction:Vector2) -> void:
	self.id = new_id
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.frame = object_sprite
	apply_central_force(new_direction.normalized() * speed)
