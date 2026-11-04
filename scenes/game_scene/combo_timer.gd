extends Control
class_name ComboTimerControl

@onready var hand_texture: TextureRect = $RidgeTexture/HandTexture
@export var fixed_angle_counts := 7

var angle_per_increment :float
var time_per_increment :float

func _ready() -> void:
	call_deferred("update")

func update() -> void:
	angle_per_increment = -float(2 * PI / fixed_angle_counts);
	time_per_increment = float(GameplayManager.combo_duration / fixed_angle_counts);

func _process(delta: float) -> void:
	if hand_texture == null:
		return
	if GameplayManager.combo_current_timer < 0.0:
		return
	
	var increment_count = roundf(GameplayManager.combo_current_timer / time_per_increment)
	hand_texture.rotation = angle_per_increment * increment_count
