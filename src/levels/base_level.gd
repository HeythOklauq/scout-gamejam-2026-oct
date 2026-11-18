extends Node3D
class_name BaseLevel

signal change_level_required(level :MainGameNode.LEVELS)

@export var player_spawners :Dictionary[String, Node3D] = {}

func get_player_spawn(_previous_scene_uid :String) -> Node3D:
	var targeted_spawner = player_spawners.values()[0]
	if _previous_scene_uid != null and player_spawners.has(_previous_scene_uid):
		targeted_spawner = player_spawners[_previous_scene_uid]
	
	return targeted_spawner
