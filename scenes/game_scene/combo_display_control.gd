extends Control
class_name ComboDisplayControl

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var combo_counter_label: Label = %ComboCounterLabel
@onready var hand_texture: TextureRect = %HandTexture

@export var fixed_angle_counts := 7
var angle_per_increment :float
var time_per_increment :float

func _ready() -> void:
	GameplayManager.combo_changed.connect(_on_combo_changed);
	call_deferred("update")

func _on_combo_changed(_modifier: int) -> void:
	if GameplayManager.combo_counter == 0:
		animation_player.play("Disappear")
		return 
	
	combo_counter_label.text = str(GameplayManager.combo_counter)
	if GameplayManager.combo_counter == 1:
		animation_player.play("Appear")
	else:
		animation_player.play("Bump")

func update() -> void:
	angle_per_increment = -float(2 * PI / fixed_angle_counts);
	time_per_increment = float(GameplayManager.combo_duration / fixed_angle_counts);

func _process(_delta: float) -> void:
	if hand_texture == null:
		return
	if GameplayManager.combo_current_timer <= 0.0:
		return
	
	var increment_count = roundf(GameplayManager.combo_current_timer / time_per_increment)
	hand_texture.rotation = angle_per_increment * increment_count
