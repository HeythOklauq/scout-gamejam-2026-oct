extends Node
class_name InteractableBodyComponent

const INTERACTIBLE_SHADER = preload("uid://cqas26bf4crwg")

@export var body :PhysicsBody3D
@export var mesh :MeshInstance3D:
	set(_mesh):
		mesh = _mesh;
		if mesh != null:
			default_mesh_shader = mesh.get_surface_override_material(0);
var default_mesh_shader :StandardMaterial3D

func _ready() -> void:
	mesh = mesh
	
	if body != null:
		body.set_collision_layer_value(3, true);

func select() -> void:
	mesh.set_surface_override_material(0, INTERACTIBLE_SHADER)

func unselect() -> void:
	mesh.set_surface_override_material(0, default_mesh_shader)

static func get_interactable_component(node :Node3D) -> InteractableBodyComponent:
	var result :InteractableBodyComponent
	
	for child in node.get_children():
		if child is InteractableBodyComponent:
			return (child as InteractableBodyComponent)
	
	return result
