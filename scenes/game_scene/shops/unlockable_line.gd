@tool
extends HBoxContainer
class_name UnlockableLineContainer

signal on_upgrade()

@onready var name_label: Label = $NameLabel
@onready var level_label: Label = $LevelLabel
@onready var upgrade_button: Button = $VBoxContainer/UpgradeButton

@onready var money_currency_line_control: CurrencyLineControl = %MoneyCurrencyLineControl
@onready var woodchip_currency_line_control: CurrencyLineControl = %WoodchipCurrencyLineControl

@export var unlockable_type :GameplayManager.UNLOCKABLE_TYPES:
	set(_type):
		unlockable_type = _type
		call_deferred("update_display")
var unlockable_resource :IncrementalUnlockResource

func update_display() -> void:
	unlockable_resource = GameplayManager.UNLOCKABLES[unlockable_type]
	if unlockable_resource == null:
		return
	
	name_label.text = unlockable_resource.unlock_name
	level_label.text = str("", unlockable_resource.unlock_level)
	
	var money_upgrade :int = unlockable_resource.get_upgrade_money_price()
	money_currency_line_control.visible = (not unlockable_resource.is_max_level()) and (money_upgrade > 0)
	money_currency_line_control.set_amount(money_upgrade)
	
	var woodchip_upgrade :int = unlockable_resource.get_upgrade_woodchip_price()
	woodchip_currency_line_control.visible = (not unlockable_resource.is_max_level()) and (woodchip_upgrade > 0)
	woodchip_currency_line_control.set_amount(woodchip_upgrade)
	
	upgrade_button.visible = not unlockable_resource.is_max_level();
	upgrade_button.disabled = (!unlockable_resource.can_upgrade());
	

func _on_upgrade_button_pressed() -> void:
	unlockable_resource.upgrade()
	on_upgrade.emit()
	update_display()
