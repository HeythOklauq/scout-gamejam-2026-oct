extends Camera3D
class_name PlayerCamera

@export var target :Node3D
@export var update_position := false
@export var update_rotation := false
@export var physics_update_position := false
@export var physics_update_rotation := false
@export var deferred_update := false
@export var starts_at_origin := false

func _ready() -> void:
	global_position = Vector3.ZERO

func _process(_delta: float) -> void:
	try_update_camera(false)

func _physics_process(_delta: float) -> void:
	try_update_camera(true)

func try_update_camera(physics_based :bool):
	if target == null:
		return
	
	if !physics_update_position || !physics_update_rotation:
		if deferred_update:
			Callable(update_camera.bind(physics_based)).call_deferred()
		else:
			update_camera(physics_based)

func update_camera(is_physics_based :bool) -> void:
	if update_position && physics_update_position == is_physics_based:
		global_position = target.global_position
	if update_rotation && physics_update_rotation == is_physics_based:
		global_rotation = target.global_rotation
