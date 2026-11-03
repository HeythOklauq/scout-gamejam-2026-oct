@tool
extends Control
class_name CurrencyLineControl

@onready var money_label: Label = $MoneyLabel
@onready var wood_chip_symbol_container: Control = $WoodChipContainer
@onready var amount_label: Label = $AmountLabel

@export var static_value := false
@export var currency_type :GameplayManager.CURRENCIES = GameplayManager.CURRENCIES.MONEY

func _ready() -> void:
	call_deferred("_initialize")

func _initialize() -> void:
	if not static_value:
		if currency_type == GameplayManager.CURRENCIES.MONEY:
			prints("LINK TO MONEY")
			GameplayManager.money_changed.connect(_update_amout)
		if currency_type == GameplayManager.CURRENCIES.WOODCHIP:
			prints("LINK TO WOODCHIP")
			GameplayManager.woodchip_changed.connect(_update_amout)
	update_display()

func update_display() -> void:
	money_label.visible = (currency_type == GameplayManager.CURRENCIES.MONEY)
	wood_chip_symbol_container.visible = (currency_type == GameplayManager.CURRENCIES.WOODCHIP)

func get_player_amount() -> int:
	return GameplayManager.player_currencies[currency_type]

func set_amount(_value :int) -> void:
	amount_label.text = str(_value);

func _update_amout(_value :int) -> void:
	if not static_value:
		set_amount(get_player_amount());
