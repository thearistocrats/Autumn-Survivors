extends Node2D

@export var racer_scene:PackedScene
@export var num_racers:int
func _ready() -> void:
	$Racer/CollidableObject.set_object(1,0,20,Vector2(1,1),50)
	$Racer2/CollidableObject.set_object(1,0,20,Vector2(-1,1),50)
	spawn_racers()

func spawn_racers():
	for i in range(num_racers):
		return
