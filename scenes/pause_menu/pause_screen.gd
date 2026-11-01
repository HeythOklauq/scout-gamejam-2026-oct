extends Control
class_name PauseScreenControl

@export var hud_control :Control

@onready var main_menu: Control = $MarginContainer/MainMenu
@onready var option_control: OptionScreenNode = $MarginContainer/OptionControl
@onready var credit_screen: CreditScreenNode = $MarginContainer/CreditScreen

func _ready() -> void:
	call_deferred("activate")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if visible:
			go_back()
		else:
			activate()

func activate() -> void:
	visible = true
	hud_control.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SlowMotionManager.pause_time()

func deactivate() -> void:
	visible = false
	hud_control.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SlowMotionManager.resume_time()

func go_back() -> void:
	if option_control.visible or credit_screen.visible:
		main_menu.visible = true
		credit_screen.visible = false
		option_control.visible = false
	else:
		deactivate()

func _on_play_button_pressed() -> void:
	deactivate()

func _on_options_button_pressed() -> void:
	main_menu.visible = false
	option_control.visible = true

func _on_option_control_close_clicked() -> void:
	main_menu.visible = true
	option_control.visible = false


func _on_credits_button_pressed() -> void:
	main_menu.visible = false
	credit_screen.visible = true

func _on_credit_screen_close_clicked() -> void:
	main_menu.visible = true
	credit_screen.visible = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()
