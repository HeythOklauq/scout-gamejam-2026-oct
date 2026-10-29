extends Node3D
class_name WoodyNode
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_hit() -> void:
	animation_player.play("Hit")
