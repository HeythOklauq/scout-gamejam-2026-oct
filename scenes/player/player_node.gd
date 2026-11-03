extends CharacterBody3D
class_name PlayerNode

@onready var camera_anchor :Node3D = $CameraAnchor
@onready var hitzone_collision_shape: CollisionShape3D = $HitzoneCollisionShape
@onready var forward_marker_3d: Marker3D = $GameCanvas/SubViewportContainer/SubViewport/PlayerCamera/ForwardMarker3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _init() -> void:
	GameplayManager.player_node = self


func turn_player(movement :Vector2) -> void:
	if Engine.time_scale == 0.0:
		return
	
	var camera_sensibility = Vector2(10.0, 10.0);
	rotation_degrees.y -= deg_to_rad(movement.x) * camera_sensibility.x;
	camera_anchor.rotation_degrees.x = clampf(camera_anchor.rotation_degrees.x - deg_to_rad(movement.y) * camera_sensibility.x, -80.0, 80.0);

func get_horizontal_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z);

func get_player_forward_angle() -> Vector3:
	return (forward_marker_3d.global_position - camera_anchor.global_position)

func apply_movement(movement :Vector3, strength :float) -> void:
	velocity += movement.normalized() * strength
	
func apply_relative_movement(relative_movement :Vector3, strength :float) -> void:
	var forward_angle = get_player_forward_angle()
	forward_angle.y = 0.0;
	
	var forward_velocity = forward_angle * relative_movement.x
	var side_velocity = forward_angle.rotated(Vector3.UP, deg_to_rad(90)) * relative_movement.z
	apply_movement(forward_velocity + side_velocity, strength)

func _physics_process(_delta: float) -> void:
	var h_dampening :Vector2 = get_horizontal_velocity().normalized() * (-GameplayManager.damping_speed) * _delta
	velocity += Vector3(h_dampening.x, 0.0, h_dampening.y)
	
	if abs(velocity.x) < GameplayManager.damping_speed * _delta:
		velocity.x = 0;
	if abs(velocity.z) < GameplayManager.damping_speed * _delta:
		velocity.z = 0;
	move_and_slide();

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		turn_player(event.relative);

func _process(_delta: float) -> void:
	turn_player(Vector2(Input.get_axis("PivotLeft", "PivotRight"), Input.get_axis("PivotUp", "PivotDown")) * 20.0)
	
	if Input.is_action_just_pressed("Interact") and active_interactable_node != null:
		active_interactable_node = active_interactable_node as InteractableBodyComponent;
		active_interactable_node.interact()

var active_interactable_node

func _on_interaction_area_entered(node) -> void:
	var interactable_component = InteractableBodyComponent.get_interactable_component(node);
	if interactable_component == null:
		return
	
	if not active_interactable_node == null:
		active_interactable_node.unselect()
	
	if not interactable_component == null:
		active_interactable_node = interactable_component
		interactable_component.select()

func _on_interaction_area_exited(node) -> void:
	var interactable_component = InteractableBodyComponent.get_interactable_component(node);
	if interactable_component == null:
		return
	
	if active_interactable_node == interactable_component:
		active_interactable_node = null;
		interactable_component.unselect()

func _on_pickup_area_body_entered(body: Node3D) -> void:
	if not is_on_floor():
		return
	var woodchip := body as WoodChipNode
	if woodchip == null:
		return
	
	woodchip.pick_up()
