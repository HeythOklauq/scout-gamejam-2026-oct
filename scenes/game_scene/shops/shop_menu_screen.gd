extends Control
class_name ShopScreenNode

signal close_pressed()

const UNLOCKABLE_LINE_PREFAB = preload("uid://5jf3dhs360cf")
@onready var product_container: VBoxContainer = %ProductContainer

@export var product_types :Array[GameplayManager.UNLOCKABLE_TYPES] = []

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	update_shop()

func update_shop() -> void:
	for child in product_container.get_children():
		child.queue_free()
	
	for product_type in product_types:
		var tmp_line = UNLOCKABLE_LINE_PREFAB.instantiate() as UnlockableLineContainer
		tmp_line.on_upgrade.connect(_on_product_upgrade)
		tmp_line.unlockable_type = product_type
		product_container.add_child(tmp_line)

func refresh_shop() -> void:
	for child in product_container.get_children():
		child = child as UnlockableLineContainer
		child.update_display()

func _on_product_upgrade() -> void:
	refresh_shop()

func _on_close_button_pressed() -> void:
	close_pressed.emit()

func go_back() -> void:
	close_pressed.emit()
