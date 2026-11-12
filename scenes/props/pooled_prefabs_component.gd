extends Node
class_name PoolPrefabComponent

signal instanciate_prefab(node :Node)
signal reinstanciate_prefab(node :Node)
signal uninstanciate_prefab(node :Node)

enum INSTANCE_STATUS {
	ALL,
	FREE,
	USED
}

@export var prefab :PackedScene
@export var pool_size := 10

var _free_prefabs :Array[Node] = []
var _used_prefabs :Array[Node] = []

func _ready() -> void:
	for index in pool_size:
		var tmp_instance = prefab.instantiate()
		_free_prefabs.push_back(tmp_instance)

func get_instance() -> Node:
	var tmp_instance
	if _free_prefabs.is_empty():
		tmp_instance = _used_prefabs.pop_front();
		reinstanciate_prefab.emit(tmp_instance);
		instanciate_prefab.emit(tmp_instance);
	else:
		tmp_instance = _free_prefabs.pop_front();
		instanciate_prefab.emit(tmp_instance);
	
	_used_prefabs.push_back(tmp_instance);
	
	return tmp_instance

func get_instances( status :INSTANCE_STATUS ) -> Array[Node]:
	var result :Array[Node] = []
	if [INSTANCE_STATUS.ALL, INSTANCE_STATUS.FREE].has(status):
		result.append_array(_free_prefabs)
	if [INSTANCE_STATUS.ALL, INSTANCE_STATUS.USED].has(status):
		result.append_array(_used_prefabs)
	return result

func reset_instances() -> void:
	pass

func uninstantiate(node :Node) -> void:
	if not _used_prefabs.has(node):
		return
	
	_used_prefabs.remove_at(_used_prefabs.find(node));
	_free_prefabs.push_back(node);
	uninstanciate_prefab.emit(node);
