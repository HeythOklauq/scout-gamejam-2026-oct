extends Node
class_name MainGameNode

# Level strutural data
enum LEVELS {
	MAIN_MENU,
	FOREST_CLEARING
}

const LEVEL_UIDS :Dictionary[LEVELS, String] = {
	LEVELS.MAIN_MENU: "uid://b7gm2agxtl0ne",
	LEVELS.FOREST_CLEARING: "uid://blygvalsnvb35"
}
var _previous_level_uid :String = ""
var _current_level :BaseLevel

# Player strutural data
const PLAYER_NODE_UID :String = "uid://cwk7yh52bw2lt"
var player :PlayerNode

# Main Game Root nodes
@onready var level_root: Node3D = %LevelRoot
@onready var entity_root: Node3D = %EntityRoot
@onready var effect_root: Node3D = %EffectRoot

# UI nodes
@onready var hud_control: HUDControl = %HUDControl
@onready var pause_screen: PauseScreenControl = %PauseScreen
@onready var transition_node: TransitionScreen = %TransitionNode

func _ready() -> void:
	load_level(LEVELS.MAIN_MENU)

func _initialise_player() -> void:
	var player_scene :PackedScene = ResourceLoader.load(PLAYER_NODE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_NODE_UID)
		return
	
	player = player_scene.instantiate() as PlayerNode
	if player == null:
		push_error("Loaded player isn't a PlayerNode" + PLAYER_NODE_UID)
		return
	
	entity_root.add_child(player)

static func get_node_uid(scene :Node) -> String:
	return ResourceUID.id_to_text(ResourceLoader.get_resource_uid(scene.scene_file_path))

func load_level(level_id :LEVELS) -> void:
	get_tree().paused = true
	transition_node.appear()
	_deferred_load_level.call_deferred(level_id)

func _deferred_load_level(level_id :LEVELS) -> void:
	_previous_level_uid = ""
	if _current_level != null:
		_previous_level_uid = MainGameNode.get_node_uid(_current_level)
		_current_level.queue_free();
		_current_level = null
	
	await get_tree().process_frame
	
	var new_level_packed :PackedScene = ResourceLoader.load(LEVEL_UIDS[level_id], "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Could not load level scene: " + LEVEL_UIDS[level_id])
		return
	
	_current_level = new_level_packed.instantiate()
	if not _current_level is BaseLevel:
		push_error("Loaded level isn't a BaseLevel" + LEVEL_UIDS[level_id])
		return
	
	_current_level.change_level_required.connect(load_level)
	
	level_root.add_child(_current_level)
	await get_tree().process_frame
	
	if _current_level is WorldLevel:
		_initialise_player()
		_place_player_in_level()
	
	transition_node.disappear()
	get_tree().paused = false

func _place_player_in_level() -> void:
	if player == null:
		push_error("No player set")
		return
	if _current_level == null:
		push_error("No level set")
		return
	
	var level_spawn = _current_level.get_player_spawn(_previous_level_uid)
	if level_spawn == null:
		push_error("No spawn point found in the level for previous UID: " + _previous_level_uid)
		return
	
	player.global_position = level_spawn.global_position
	player.global_rotation = level_spawn.global_rotation
