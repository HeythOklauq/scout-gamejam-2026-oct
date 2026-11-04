@tool
extends Node

signal unlockable_updated(unlockable_resource :IncrementalUnlockResource)
signal pickup_lock_changed()
signal dashing_changed()

signal stamina_changed(value :int)
signal combo_changed(value :int)
signal woodchip_changed(modifier :int);
signal money_changed(modifier :int);

enum CURRENCIES {
	MONEY,
	WOODCHIP
}

var player_currencies :Dictionary[CURRENCIES, int] = {
	CURRENCIES.MONEY: 0,
	CURRENCIES.WOODCHIP: 0
}

#region UNLOCKABLES

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

func on_unlockable_updated( unlockable_resource :IncrementalUnlockResource ) -> void:
	unlockable_updated.emit(unlockable_resource)
	save_data()
#endregion

var dashing := false:
	set(_dashing):
		dashing = _dashing
		dashing_changed.emit()

var attack_locked := false
var stamina_locked := false
var pickup_locked := false:
	set(_pickup_locked):
		pickup_locked = _pickup_locked
		pickup_lock_changed.emit()


var player_node :PlayerNode

#region COMBO
@export var combo_duration := 0.8
var combo_current_timer := 0.0
var combo_timer_ticking := true
var combo_timer_speed_multiplier := 1.0
var combo_counter := 0:
	set(_combo_counter):
		if not UNLOCKABLES[UNLOCKABLE_TYPES.POGO].is_unlocked():
			return
		
		if _combo_counter > 0:
			reset_combo_timer()
		
		combo_counter = _combo_counter
		combo_changed.emit(combo_counter)

func reset_combo_timer() -> void:
	combo_current_timer = combo_duration
	combo_timer_ticking = false

func _update_combo(_delta :float) -> void:
	if combo_current_timer <= 0.0:
		return
	
	if player_node.is_on_floor():
		combo_timer_ticking = true
	
	if not combo_timer_ticking:
		return
	
	combo_current_timer -= _delta * combo_timer_speed_multiplier
	if combo_current_timer <= 0.0:
		combo_counter = 0;
#endregion

#region Movement stats
@export_group("Movement Stats")
@export var damping_speed := 100.0;
@export var walking_speed := 400.0;
var squared_max_walking_speed := 0.0;
@export var max_walking_speed := 5.0:
	set(_speed):
		max_walking_speed = _speed
		squared_max_walking_speed = pow(max_walking_speed, 2);
@export var jump_speed := 10.0;
@export var falling_speed := 2.0;
@export var dash_speed := 20.0;
@export var knockback_strength := 20.0
#endregion

#region STAMINA

@export_group("Stamina")
@export var max_stamina := 100.0:
	set(_max_stamina):
		max_stamina = _max_stamina
		stamina_changed.emit();
@export var current_stamina := 0.0;
## Stamina consumption by action
@export var stamina_usage := 30.0:
	set(_stamina_usage):
		stamina_usage = _stamina_usage
		stamina_changed.emit();
## Stamina regen per seconds
@export var stamina_regen := 10.0;

func can_use_stamina() -> bool:
	return (current_stamina >= stamina_usage);

func use_stamina() -> void:
	current_stamina -= stamina_usage;

func _update_stamina(delta :float) -> void:
	if not stamina_locked and current_stamina < max_stamina:
		current_stamina = min(current_stamina + stamina_regen * delta, max_stamina);

#endregion

func _get_configuration_warnings():
	var warnings := []
	for _unlockable_key in UNLOCKABLES.keys():
		var unlockable_label = UNLOCKABLE_TYPES.keys()[_unlockable_key]
		var unlockable_resource = UNLOCKABLES[_unlockable_key]
		for resource_warning in unlockable_resource._get_configuration_warnings():
			warnings.push_back(str(unlockable_label, " - ", resource_warning))
	return warnings

func _ready() -> void:
	call_deferred("initialize")

func _process(delta: float) -> void:
	_update_stamina(delta)
	_update_combo(delta)

func initialize() -> void:
	current_stamina = max_stamina
	max_walking_speed = max_walking_speed;
	
	load_data()
	
	for unlockable_resource in UNLOCKABLES.values():
		(unlockable_resource as IncrementalUnlockResource).updated.connect(on_unlockable_updated)

func modify_currency(type :CURRENCIES, modifier :int) -> void:
	GameplayManager.player_currencies[type] += modifier
	
	if type == CURRENCIES.WOODCHIP:
		prints("CURRENCIES.WOODCHIP: ", modifier)
		woodchip_changed.emit(modifier)
	elif type == CURRENCIES.MONEY:
		prints("CURRENCIES.MONEY: ", modifier)
		money_changed.emit(modifier)


#region SAVE DATA
var data_file_path :String = "user://gameplay_data.json"


func get_data() -> Dictionary:
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
	
	return data

func load_gameplay_data(data :Dictionary) -> void:
	for currency_name in CURRENCIES.keys():
		var currency_id = CURRENCIES[currency_name]
		if data["currencies"].has(currency_name):
			call_deferred("modify_currency", currency_id, data["currencies"][currency_name])
	
	for unlockable_name in UNLOCKABLE_TYPES.keys():
		var unlockable_type = UNLOCKABLE_TYPES[unlockable_name]
		if data["unlockables"].has(unlockable_name):
			var current_unlockable = UNLOCKABLES[unlockable_type]
			current_unlockable.unlock_level = data["unlockables"][unlockable_name].unlock_level
			current_unlockable.current_level = data["unlockables"][unlockable_name].current_level

func reset_data() -> void:
	combo_counter = 0
	combo_current_timer = 0.0
	
	for currency_name in CURRENCIES.keys():
		player_currencies[CURRENCIES[currency_name]] = 0
	
	for unlockable_name in UNLOCKABLE_TYPES.keys():
		var unlockable_type = UNLOCKABLE_TYPES[unlockable_name]
		UNLOCKABLES[unlockable_type].unlock_level = 0
		UNLOCKABLES[unlockable_type].current_level = 0
	
	money_changed.emit(0)
	woodchip_changed.emit(0)
	call_deferred("save_data")

func load_data() -> void:
	if FileAccess.file_exists(data_file_path):
		var file = FileAccess.open(data_file_path, FileAccess.READ)
		var file_content = file.get_as_text()
		file.close()
		
		var file_parsed = JSON.parse_string(file_content)
		prints(file_parsed)
		load_gameplay_data(file_parsed)

func save_data() -> void:
	var file = FileAccess.open(data_file_path, FileAccess.WRITE_READ)
	var option_data = JSON.stringify(get_data())
	prints(option_data)
	file.store_string(option_data)
	file.close()
#endregion
