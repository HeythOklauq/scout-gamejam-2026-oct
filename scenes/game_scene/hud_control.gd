extends Control
class_name HUDControl

@onready var cigarette_timer: HBoxContainer = %CigaretteTimer

@onready var combo_counter: Label = %ComboCounter
@onready var money_currency_line_control: CurrencyLineControl = $MarginContainer/VBoxContainer/ScoreConatiner/MoneyCurrencyLineControl
@onready var woodchip_currency_line_control: CurrencyLineControl = $MarginContainer/VBoxContainer/ScoreConatiner/WoodchipCurrencyLineControl

var previous_max_stamina :float;
var previous_stamina_usage :float;
@onready var stamina_bar: StaminaBar = %StaminaBar

func _ready() -> void:
	call_deferred("initialise")

func initialise() -> void:
	update_combo()
	update_money()
	update_woodchips()
	update_stamina()
	GameplayManager.combo_changed.connect(_on_combo_changed)
	GameplayManager.money_changed.connect(_on_money_changed)
	GameplayManager.woodchip_changed.connect(_on_woodchip_changed)
	GameplayManager.stamina_changed.connect(_on_stamina_changed)


func update_combo() -> void:
	combo_counter.text = str(GameplayManager.combo_counter)

func update_money() -> void:
	money_currency_line_control.set_amount(GameplayManager.player_currencies[GameplayManager.CURRENCIES.MONEY])

func update_woodchips() -> void:
	woodchip_currency_line_control.set_amount(GameplayManager.player_currencies[GameplayManager.CURRENCIES.WOODCHIP])

func update_stamina() -> void:
	if GameplayManager.max_stamina != previous_max_stamina or GameplayManager.stamina_usage != previous_stamina_usage:
		stamina_bar.update_segment_count()

func _on_combo_changed(_modifier: int) -> void:
	update_combo()

func _on_money_changed(_modifier: int) -> void:
	update_money()

func _on_woodchip_changed(_modifier: int) -> void:
	update_woodchips()

func _on_stamina_changed(_modifier :int) -> void:
	update_stamina()
