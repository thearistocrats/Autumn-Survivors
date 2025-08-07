extends RigidBody2D

func set_size(new_size:Vector2i) -> void:
	$CollisionShape2D.shape.size = new_size
