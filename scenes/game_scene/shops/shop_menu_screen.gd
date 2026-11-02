extends Control
class_name ShopScreenNode

const UNLOCKABLE_LINE_PREFAB = preload("uid://5jf3dhs360cf")
@onready var product_container: VBoxContainer = $VBoxContainer/ScrollContainer/MarginContainer/ProductContainer

@export var product_types :Array[GameplayManager.UNLOCKABLE_TYPES] = []

func _ready() -> void:
	call_deferred("update_shop")

func update_shop() -> void:
	for child in product_container.get_children():
		child.queue_free()
	
	for product_type in product_types:
		var tmp_line = UNLOCKABLE_LINE_PREFAB.instantiate() as UnlockableLineContainer
		tmp_line.unlockable_type = product_type
		product_container.add_child(tmp_line)
