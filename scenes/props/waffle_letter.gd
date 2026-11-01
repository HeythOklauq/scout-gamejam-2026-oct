@tool
extends Node3D
class_name WaffleLetterNode

@onready var label_3d: Label3D = $Label3D

@export var default_font_size := 110
@export var smaller_font_size := 80

@export var letter := "A":
	set(_letter):
		letter = _letter
		
		var font_size = default_font_size
		if _letter.length() == 2:
			font_size = smaller_font_size
		
		if not label_3d == null:
			label_3d.font_size = font_size
			label_3d.text = letter

func _ready() -> void:
	letter = letter
