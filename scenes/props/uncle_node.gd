extends Node3D
class_name UncleNode

@onready var sprite_3d: Sprite3D = $Sprite3D

@export var animation_speed = 1.0
@export var animation_time := 0.5
var current_timer := animation_time

func _process(delta: float) -> void:
	current_timer -= delta * animation_speed
	
	if current_timer <= 0.0:
		current_timer = animation_time
		
		sprite_3d.frame = (sprite_3d.frame + 1) % sprite_3d.hframes
