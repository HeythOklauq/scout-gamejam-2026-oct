@tool
extends HBoxContainer
class_name UnlockableLineContainer

@onready var name_label: Label = $NameLabel
@onready var level_label: Label = $LevelLabel
@onready var upgrade_button: Button = $VBoxContainer/UpgradeButton

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
	upgrade_button.visible = not unlockable_resource.is_max_level();
	upgrade_button.disabled = unlockable_resource.can_upgrade();

func _on_upgrade_button_pressed() -> void:
	pass # Replace with function body.
