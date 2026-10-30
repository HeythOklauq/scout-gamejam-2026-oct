extends CharacterBody3D
class_name PlayerNode

const WOOD_IMPACT_PARTICLE = preload("res://scenes/game_scene/wood_impact_particle.tscn")

@onready var camera_3d: Camera3D = $Camera3D
@onready var hurt_zone_area: Area3D = $Camera3D/HurtZoneArea
@onready var hitzone_collision_shape: CollisionShape3D = $HitzoneCollisionShape
@onready var forward_marker_3d: Marker3D = $Camera3D/ForwardMarker3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var pause_menu_control: ColorRect = %PauseMenuControl

var attack_locked := false;

@export_group("Movement Stats")
@export var damping_speed = 100.0;
@export var walking_speed = 400.0;
var squared_max_walking_speed = 0.0;
@export var max_walking_speed = 5.0:
	set(_speed):
		max_walking_speed = _speed
		squared_max_walking_speed = pow(max_walking_speed, 2);
@export var jump_speed = 10.0;
@export var falling_speed = 2.0;
@export var dash_speed = 20.0;
@export var knockback_strength = 20.0

func _ready() -> void:
	max_walking_speed = max_walking_speed;
	call_deferred("_on_pause_menu_control_visibility_changed")

func turn_player(movement :Vector2) -> void:
	if Engine.time_scale == 0.0:
		return
	
	var camera_sensibility = Vector2(10.0, 10.0);
	rotation_degrees.y -= deg_to_rad(movement.x) * camera_sensibility.x;
	camera_3d.rotation_degrees.x = clampf(camera_3d.rotation_degrees.x - deg_to_rad(movement.y) * camera_sensibility.x, -80.0, 80.0);

func get_horizontal_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z);

func get_player_forward_angle() -> Vector3:
	return (forward_marker_3d.global_position - camera_3d.global_position)

func apply_movement(movement :Vector3, strength :float) -> void:
	velocity += movement.normalized() * strength
	
func apply_relative_movement(relative_movement :Vector3, strength :float) -> void:
	var forward_angle = get_player_forward_angle()
	forward_angle.y = 0.0;
	
	var forward_velocity = forward_angle * relative_movement.x
	var side_velocity = forward_angle.rotated(Vector3.UP, deg_to_rad(90)) * relative_movement.z
	apply_movement(forward_velocity + side_velocity, strength)

func _physics_process(delta: float) -> void:
	var h_dampening :Vector2 = get_horizontal_velocity().normalized() * (-damping_speed) * delta
	velocity += Vector3(h_dampening.x, 0.0, h_dampening.y)
	
	if abs(velocity.x) < damping_speed * delta:
		velocity.x = 0;
	if abs(velocity.z) < damping_speed * delta:
		velocity.z = 0;
	move_and_slide();


func attack() -> void:
	if animation_player.is_playing():
		return
	
	animation_player.play("Attack")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		turn_player(event.relative);
	
	if Input.is_action_just_pressed("Pause"):
		pause_menu_control.visible = !pause_menu_control.visible

func _process(delta: float) -> void:
	turn_player(Vector2(Input.get_axis("PivotLeft", "PivotRight"), Input.get_axis("PivotUp", "PivotDown")) * 20.0)

func get_hit() -> void:
	pass

func _on_hurt_zone_area_body_entered(body: Node3D) -> void:
	hit_target(body);

func hit_target(node3d :Node3D) -> void:
	animation_player.stop();
	animation_player.play("KnockedBack");
	
	SlowMotionManager.slow_time(SlowMotionManager.MAJOR_SLOW, 0.5);
	
	var hit_normal = -get_player_forward_angle()
	if is_on_floor():
		hit_normal.y = 0;
	velocity.y = 0
	apply_movement(hit_normal, knockback_strength);
	
	
	var target = node3d.find_parent("WoodyNode")
	if not target == null:
		target.on_hit()
	
	var tmp_particle = WOOD_IMPACT_PARTICLE.instantiate() as WoodImpactParticle
	tmp_particle.global_position = forward_marker_3d.global_position
	get_tree().root.add_child(tmp_particle)

var interactable_nodes = []

func _on_interaction_area_3d_area_entered(area: Area3D) -> void:
	pass # Replace with function body.

func _on_interaction_area_3d_area_exited(area: Area3D) -> void:
	pass # Replace with function body.

func _on_pause_menu_control_visibility_changed() -> void:
	if pause_menu_control == null:
		return;
	
	if pause_menu_control.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		SlowMotionManager.pause_time()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		SlowMotionManager.resume_time()
