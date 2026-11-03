@tool
extends Control
class_name CurrencyLineControl

@onready var money_label: Label = $MoneyLabel
@onready var wood_chip_symbol_container: Control = $WoodChipContainer
@onready var amount_label: Label = $AmountLabel

@export var currency_type :GameplayManager.CURRENCIES

func _ready() -> void:
	call_deferred("_initialize")

func _initialize() -> void:
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

func get_amount() -> int:
	return GameplayManager.player_currencies[currency_type]

func _update_amout(_value :int) -> void:
	prints("_update_amout")
	amount_label.text = str(get_amount());
