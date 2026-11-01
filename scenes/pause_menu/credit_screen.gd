extends Control
class_name CreditScreenNode

signal close_clicked()

func _on_close_button_pressed() -> void:
	close_clicked.emit()
