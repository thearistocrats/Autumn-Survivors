extends Node2D

@export var racer_scene:PackedScene
@export var num_racers:int
func _ready() -> void:
	spawn_racers()
	#_debug()
	
func _debug():pass
	

func spawn_racers():
	var spawn_position = get_viewport_rect().size/4
	var racer_offset = 40
	var spawn_grid = 8
	for i in range(num_racers):
		var new_racer = racer_scene.instantiate()
		new_racer.set_object(i, i, 10000, Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0)))
		new_racer.position = Vector2(spawn_position.x + (i % 8 * racer_offset), spawn_position.y + (i / 8 * racer_offset))
		add_child(new_racer)
