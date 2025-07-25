extends Node2D

@export var racer_scene:PackedScene
@export var num_racers:int
func _ready() -> void:
	#spawn_racers()
	_debug()
	
func _debug():
	var spawn_position = get_viewport_rect().size/4
	var racer_offset = 200
	var spawn_grid = 8
	var new_racer = racer_scene.instantiate()
	new_racer.get_child(0).set_object(1, 0, 50, Vector2(1,1), 100)
	new_racer.position = Vector2(spawn_position.x + (0 % 8 * racer_offset), spawn_position.y + (0 / 8 * racer_offset))
	add_child(new_racer)
	new_racer = racer_scene.instantiate()
	new_racer.get_child(0).set_object(1, 1, 50, Vector2(-1,1), 100)
	new_racer.position = Vector2(spawn_position.x + (1 % 8 * racer_offset), spawn_position.y + (1 / 8 * racer_offset))
	add_child(new_racer)
	

func spawn_racers():
	var spawn_position = get_viewport_rect().size/4
	var racer_offset = 20
	var spawn_grid = 8
	for i in range(num_racers):
		var new_racer = racer_scene.instantiate()
		new_racer.get_child(0).set_object(1, i, 50, Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0)), 100)
		new_racer.position = Vector2(spawn_position.x + (i % 8 * racer_offset), spawn_position.y + (i / 8 * racer_offset))
		add_child(new_racer)
