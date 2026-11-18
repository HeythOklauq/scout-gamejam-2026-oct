extends BaseLevel


func _on_play_button_pressed() -> void:
	change_level_required.emit(MainGameNode.LEVELS.FOREST_CLEARING)

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
