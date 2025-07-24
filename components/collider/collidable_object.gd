class_name CollidableObject extends Area2D
@export_category("object")
var object_type : collision_logic.object_type
@export_category("physical properties")
var mass : int
var damping = 0.0
@export_category("mechanical properties")
var speed : int
var velocity : Vector2

func set_object(new_object_type:int, object_sprite:int, new_speed:int, direction:Vector2, new_mass:int):
	self.object_type = new_object_type
	self.speed = new_speed
	self.velocity = direction.normalized() * new_speed
	self.mass = new_mass
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.frame = object_sprite

func set_object_material(new_mass:int, new_damping:float):
	self.mass = new_mass
	self.damping = new_damping
	
func _physics_process(delta: float) -> void:
	self.position += self.velocity * delta

func _on_area_entered(area: Area2D) -> void:
	self.velocity = collision_logic.get_collision_velocity(self, area)
