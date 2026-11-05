extends Node3D
class_name DamageNumberNode

@onready var label_3d: Label3D = $Label3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var order_suffixes := ["", "k", "M", "B"]

func get_damage_str(damage :float, current_order_increment := 0) -> String:
	var result :String
	
	if damage > 1000.0:
		result = get_damage_str(int(damage)/1000.0, current_order_increment + 1)
	else:
		result = str(round(damage * 100.0)/100.0) + order_suffixes[current_order_increment]
	
	return result

func show_damage(damage :float) -> void:
	timer.stop()
	label_3d.text = get_damage_str(damage)
	animation_player.play("Appearing")


func _on_timer_timeout() -> void:
	animation_player.play("Disappearing")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Appearing":
		timer.start()
