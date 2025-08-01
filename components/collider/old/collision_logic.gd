class_name collision_logic

enum object_type {
	WALL, RACER, PLAYER, PROJECTILE, DESTRUCTABLE, PICKUP
}

enum damping_type {
	AVERAGE, MULTIPLICATIVE, MIN, MAX
}

static func get_normal(object_self, object_other) -> Vector2:
	return (object_self.position - object_other.position).normalized()
static func damping_ratio(A:float, B:float, type:int) -> float:
	match type:
		damping_type.AVERAGE:
			return A + B * 0.5
		damping_type.MULTIPLICATIVE:
			return 1.0 - ((1.0 - A) * (1.0 - B))
		damping_type.MIN:
			return minf(A,B)
		damping_type.MAX:
			return maxf(A,B)
		_:
			return 0.0

#object A gets the returned velocity applied to it
#function gets called twice per collision
#might be possible to be more efficient but im not sure if it would make collisions more complicated to handle
static func get_collision_velocity(object_self, object_other) -> Vector2:
	#early returns for error handling, should never be relied on
	#all objects should have these components
	if not object_self or not object_other:
		return Vector2.ZERO
	if object_self.velocity == null or object_other.velocity == null:
		return Vector2.ZERO
	if object_self.object_type == null or object_other.object_type == null:
		return object_self.velocity
		
	var min_type = min(object_self.object_type, object_other.object_type)
	var max_type = max(object_self.object_type, object_other.object_type)
	var is_flipped = (object_self.object_type < object_other.object_type)
	var key = [min_type, max_type]
	
	var collision_handlers = {
		[object_type.WALL, object_type.WALL]: Callable(_handle_wall_wall_collision),
		[object_type.WALL, object_type.RACER]: Callable(_handle_wall_racer_collision),
		[object_type.WALL, object_type.PLAYER]: Callable(_handle_wall_player_collision),
		[object_type.WALL, object_type.PROJECTILE]: Callable(_handle_wall_projectile_collision),
		[object_type.WALL, object_type.DESTRUCTABLE]: Callable(_handle_wall_destructable_collision),
		[object_type.WALL, object_type.PICKUP]: Callable(_handle_wall_pickup_collision),
		[object_type.RACER, object_type.RACER]: Callable(_handle_racer_racer_collision),
		[object_type.RACER, object_type.PLAYER]: Callable(_handle_racer_player_collision),
		[object_type.RACER, object_type.PROJECTILE]: Callable(_handle_racer_projectile_collision),
		[object_type.RACER, object_type.DESTRUCTABLE]: Callable(_handle_racer_destructable_collision),
		[object_type.RACER, object_type.PICKUP]: Callable(_handle_racer_pickup_collision),
		[object_type.PLAYER, object_type.PLAYER]: Callable(_handle_player_player_collision),
		[object_type.PLAYER, object_type.PROJECTILE]: Callable(_handle_player_projectile_collision),
		[object_type.PLAYER, object_type.DESTRUCTABLE]: Callable(_handle_player_destructable_collision),
		[object_type.PLAYER, object_type.PICKUP]: Callable(_handle_player_pickup_collision),
		[object_type.PROJECTILE, object_type.PROJECTILE]: Callable(_handle_projectile_projectile_collision),
		[object_type.PROJECTILE, object_type.DESTRUCTABLE]: Callable(_handle_projectile_destructable_collision),
		[object_type.PROJECTILE, object_type.PICKUP]: Callable(_handle_projectile_pickup_collision),
		[object_type.DESTRUCTABLE, object_type.DESTRUCTABLE]: Callable(_handle_destructable_destructable_collision),
		[object_type.DESTRUCTABLE, object_type.PICKUP]: Callable(_handle_destructable_pickup_collision),
		[object_type.PICKUP, object_type.PICKUP]: Callable(_handle_pickup_pickup_collision)
	}
	
	if collision_handlers.has(key):
		var normal = (object_self.position - object_other.position).normalized()
		return (collision_handlers[key].call(object_self, object_other, is_flipped, normal))
	return Vector2.ZERO

static func _handle_wall_wall_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_wall_racer_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_wall_player_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_wall_projectile_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_wall_destructable_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_wall_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping

static func _handle_racer_racer_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	return object_self.velocity.bounce(normal_vector) * damping
static func _handle_racer_player_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_racer_projectile_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_racer_destructable_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_racer_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping

static func _handle_player_player_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_player_projectile_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_player_destructable_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_player_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping

static func _handle_projectile_projectile_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_projectile_destructable_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_projectile_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping

static func _handle_destructable_destructable_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
static func _handle_destructable_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping

static func _handle_pickup_pickup_collision(object_self, object_other, is_flipped:bool, normal_vector:Vector2) -> Vector2:
	var damping = damping_ratio(object_self.damping, object_other.damping, damping_type.MAX)
	if !is_flipped: return object_self.velocity.bounce(normal_vector) + object_other.velocity * damping
	return object_other.velocity.bounce(normal_vector) + object_other.velocity * damping
