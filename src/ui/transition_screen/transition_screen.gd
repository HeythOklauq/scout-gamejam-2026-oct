extends Control
class_name TransitionScreen

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func update_progress(_progress :float) -> void:
	progress_bar.value = _progress

func appear() -> void:
	animation_player.play("Appear")

func disappear() -> void:
	animation_player.play("Disappear")
