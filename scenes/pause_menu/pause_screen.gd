extends Control
class_name PauseScreenControl

signal resume_game()

@onready var main_menu: Control = $MarginContainer/MainMenu
@onready var option_control: OptionScreenNode = $MarginContainer/OptionControl
@onready var credit_screen: CreditScreenNode = $MarginContainer/CreditScreen

func deactivate() -> void:
	resume_game.emit()

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
