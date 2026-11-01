@tool
extends HBoxContainer

@export var collaborator_name :String = "<NAME>":
	set(_name):
		collaborator_name = _name
		call_deferred("update_display")
@export var collaborator_link :String = "":
	set(_link):
		collaborator_link = _link
		call_deferred("update_display")
@export var participation_name :String = "<ROLE>":
	set(_participation):
		participation_name = _participation
		call_deferred("update_display")
@export var participation_link :String = "":
	set(_link):
		participation_link = _link
		call_deferred("update_display")

@onready var name_label: RichTextLabel = $NameLabel
@onready var role_label: RichTextLabel = $RoleLabel

func _ready() -> void:
	call_deferred("update_display")

func update_display() -> void:
	if name_label == null or role_label == null:
		call_deferred("update_display")
		return
	
	name_label.text = get_label(collaborator_name, collaborator_link)
	role_label.text = get_label(participation_name, participation_link)

func get_label(_name :String, _link :String) -> String:
	var result = _name
	if not _link == "":
		result = str("[url=", _link,"]", result, "[/url]")
	
	return result
