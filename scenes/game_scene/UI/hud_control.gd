extends Control
class_name HUDControl

@onready var cigarette_timer: HBoxContainer = %CigaretteTimer

var previous_max_stamina :float;
var previous_stamina_usage :float;
@onready var stamina_bar: StaminaBar = %StaminaBar

func _ready() -> void:
	call_deferred("initialise")

func initialise() -> void:
	update_stamina()
	GameplayManager.stamina_changed.connect(_on_stamina_changed);

func update_stamina() -> void:
	if GameplayManager.max_stamina != previous_max_stamina or GameplayManager.stamina_usage != previous_stamina_usage:
		stamina_bar.update_segment_count()

func _on_stamina_changed(_modifier :int) -> void:
	update_stamina()
