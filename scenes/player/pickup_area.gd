extends Area3D
class_name PickupArea

@export var radius := 0.5

func _ready() -> void:
	GameplayManager.pickup_lock_changed.connect(_on_pickup_lock_changed)

func _try_pick_up(body :Node3D) -> void:
	var woodchip := body as WoodChipNode
	if woodchip == null:
		return
	
	woodchip.pick_up()

func _on_pickup_lock_changed() -> void:
	if (GameplayManager.pickup_locked == true):
		return
	
	for body in get_overlapping_bodies():
		_try_pick_up(body)

func _on_pickup_area_body_entered(body: Node3D) -> void:
	if (GameplayManager.pickup_locked == true):
		return
	
	_try_pick_up(body)
