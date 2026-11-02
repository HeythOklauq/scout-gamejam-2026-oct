@tool
extends Node

enum CURRENCIES {
	MONEY,
	WOODCHIP
}

var player_currencies :Dictionary[CURRENCIES, int] = {
	CURRENCIES.MONEY: 0,
	CURRENCIES.WOODCHIP: 0
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
	
	data["currencies"] = {}
	for currency_type in CURRENCIES.keys():
		var currency_id = CURRENCIES[currency_type]
		if UNLOCKABLES.has(currency_id):
			data["currencies"][currency_type] = player_currencies[currency_id];
	
	data["unlockables"] = {}
	for unlockable_type in UNLOCKABLE_TYPES.keys():
		var type_id = UNLOCKABLE_TYPES[unlockable_type]
		if UNLOCKABLES.has(type_id):
			data["unlockables"][unlockable_type] = {
				"unlock_level": UNLOCKABLES[UNLOCKABLE_TYPES[unlockable_type]].unlock_level,
				"current_level": UNLOCKABLES[UNLOCKABLE_TYPES[unlockable_type]].current_level
			};
	
	load_data(data)
	return data

func load_data(data :Dictionary) -> void:
	for currency_type in CURRENCIES.keys():
		var currency_id = CURRENCIES[currency_type]
		if data["currencies"].has(currency_id):
			player_currencies[currency_id] = data["currencies"][currency_type];
	
	for unlockable_type in UNLOCKABLE_TYPES.keys():
		var type_id = UNLOCKABLE_TYPES[unlockable_type]
		if data["unlockables"].has(type_id):
			UNLOCKABLES[UNLOCKABLE_TYPES[unlockable_type]].unlock_level = data["unlockables"][unlockable_type].unlock_level
			UNLOCKABLES[UNLOCKABLE_TYPES[unlockable_type]].current_level = data["unlockables"][unlockable_type].current_level
