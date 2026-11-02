@tool
extends Node

enum CURRENCIES {
	MONEY,
	WOODCHIP
}

enum UNLOCKABLE_TYPES {
	POGO,
	BUNT,
	WIND_UP,
	DOWNSWING,
	STEAL,
	
	SWING,
	FLEXIBILITY,
	GUTS,
	MOXIE,
	GRACE,
	PATIENCE,
	
	PADDLE,
	BO_STAFF,
	WIZARD_STAFF,
	HELMET,
	
	SWORD,
	BOXING_GLOVE,
	SUNGLASSES,
	MENTHOL,
	SPLIFF,
	PEN_KNIFE,
	
	INFINITY,
	FLAME,
	TIC_TAC_TOE,
	HOUSE,
	ANGEL
}

@export var UNLOCKABLES :Dictionary[UNLOCKABLE_TYPES, IncrementalUnlockResource] = {}

func _get_configuration_warnings():
	var warnings := []
	for _unlockable_key in UNLOCKABLES.keys():
		var unlockable_label = UNLOCKABLE_TYPES.keys()[_unlockable_key]
		var unlockable_resource = UNLOCKABLES[_unlockable_key]
		for resource_warning in unlockable_resource._get_configuration_warnings():
			warnings.push_back(str(unlockable_label, " - ", resource_warning))
	return warnings

func _ready() -> void:
	call_deferred("save_data")

func save_data() -> Dictionary:
	var data :Dictionary = {}
	
	for unlockable_type in UNLOCKABLE_TYPES.keys():
		var type_id = UNLOCKABLE_TYPES[unlockable_type]
		if UNLOCKABLES.has(type_id):
			data[unlockable_type] = UNLOCKABLES[UNLOCKABLE_TYPES[unlockable_type]].current_unlock_level;
	
	prints(data)
	return data

func load_data(data :Dictionary) -> void:
	pass
