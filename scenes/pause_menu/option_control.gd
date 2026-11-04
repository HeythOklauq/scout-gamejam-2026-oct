extends Control
class_name OptionScreenNode

signal close_clicked()

func _on_close_button_pressed() -> void:
	close_clicked.emit()


func _on_reset_progress_button_pressed() -> void:
	GameplayManager.reset_data()
