class_name collision_logic

enum object_type {
	WALL, RACER, PLAYER, PROJECTILE, DESTRUCTABLE, PICKUP
}

enum damping_type {
	AVERAGE, MULTIPLICATIVE, MIN, MAX
}

#object A gets the returned velocity applied to it
#function gets called twice per collision
#might be possible to be more efficient but im not sure if it would make collisions more complicated to handle
static func get_collision_velocity(objectA, objectB) -> Vector2:
	#early returns for error handling, should never be relied on
	#all objects should have these components
	if not objectA or not objectB:
		return Vector2.ZERO
	if objectA.velocity == null or objectB.velocity == null:
		return Vector2.ZERO
	if objectA.object_type == null or objectB.object_type == null:
		return objectA.velocity
		
	var min_type = min(objectA.object_type, objectB.object_type)
	var max_type = max(objectA.object_type, objectB.object_type)
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
		return (collision_handlers[key].call(objectA, objectB))
	return Vector2.ZERO

static func get_normal(objectA, objectB) -> Vector2:
	return(objectA.position - objectB.position).normalized()

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

static func _handle_wall_wall_collision(objectA, objectB) -> Vector2:
	var normal = get_normal(objectA, objectB)
	return objectA.velocity * -1.0

static func _handle_wall_racer_collision(objectA, objectB) -> Vector2:
	var normal = get_normal(objectA, objectB)
	var damping_ratio = damping_ratio(objectA.damping, objectB.damping, damping_type.MAX)
	return objectA.velocity.bounce(normal) + objectB.velocity * damping_ratio

static func _handle_wall_player_collision(objectA, objectB) -> Vector2:
	if objectA.object_type == object_type.WALL: return objectA.velocity
	return Vector2.ZERO

static func _handle_wall_projectile_collision(objectA, objectB) -> Vector2:
	if objectA.object_type == object_type.WALL: return objectA.velocity
	return Vector2.ZERO

static func _handle_wall_destructable_collision(objectA, objectB) -> Vector2:
	if objectA.object_type == object_type.WALL: return objectA.velocity
	return Vector2.ZERO

static func _handle_wall_pickup_collision(objectA, objectB) -> Vector2:
	if objectA.object_type == object_type.WALL: return objectA.velocity
	return Vector2.ZERO

static func _handle_racer_racer_collision(objectA, objectB) -> Vector2:
	var normal = get_normal(objectA, objectB)
	var damping_ratio = damping_ratio(objectA.damping, objectB.damping, damping_type.MAX)
	return objectA.velocity.bounce(normal) + objectB.velocity * damping_ratio

static func _handle_racer_player_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_racer_projectile_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_racer_destructable_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_racer_pickup_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_player_player_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_player_projectile_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_player_destructable_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_player_pickup_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_projectile_projectile_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_projectile_destructable_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_projectile_pickup_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_destructable_destructable_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_destructable_pickup_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO

static func _handle_pickup_pickup_collision(objectA, objectB) -> Vector2:
	return Vector2.ZERO
