extends Control
class_name HUDControl

@onready var cigarette_timer: HBoxContainer = %CigaretteTimer

@onready var combo_counter: Label = %ComboCounter
@onready var money_currency_line_control: CurrencyLineControl = $MarginContainer/VBoxContainer/ScoreConatiner/MoneyCurrencyLineControl
@onready var woodchip_currency_line_control: CurrencyLineControl = $MarginContainer/VBoxContainer/ScoreConatiner/WoodchipCurrencyLineControl

var previous_max_stamina :float;
var previous_stamina_usage :float;
@onready var stamina_bar: StaminaBar = %StaminaBar

@export var player_node :PlayerNode

func _ready() -> void:
	call_deferred("initialise")

func initialise() -> void:
	if player_node == null:
		call_deferred("initialise")
		return
	
	stamina_bar.player_node = player_node
	update_combo()
	update_money()
	update_woodchips()
	update_stamina()


func update_combo() -> void:
	combo_counter.text = str(player_node.combo_count)


func update_money() -> void:
	money_currency_line_control.set_amount(player_node.money)


func update_woodchips() -> void:
	woodchip_currency_line_control.set_amount(player_node.woodchips)


func update_stamina() -> void:
	if player_node.max_stamina != previous_max_stamina or player_node.stamina_usage != previous_stamina_usage:
		stamina_bar.update_segment_count()

func _on_player_combo_changed(value: int) -> void:
	update_combo()

func _on_player_money_changed(value: int, modifier: int) -> void:
	update_money()

func _on_player_woodchip_changed(value: int, modifier: int) -> void:
	update_woodchips()

func _on_player_stamina_changed() -> void:
	update_stamina()
