extends Node
class_name StaminaBar

@export var segment_texture :Texture
@export var segment_texture_cracked :Texture
@onready var segment_container: HBoxContainer = $SegmentContainer

@export var default_segment_modulate_color :Color = Color.WHITE
@export var empty_segment_modulate_color :Color = Color.NAVAJO_WHITE
@export var loading_flash_speed := 1.0
var flashing_timer := 0.0

@export var player_node :PlayerNode
@export var segment_size := Vector2(64.0, 32.0)

var segments_list :Array[Control] = []

func create_segment() -> TextureRect:
	var new_segment :TextureRect = TextureRect.new()
	
	new_segment.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_segment.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_segment.custom_minimum_size = Vector2(64, 32)
	new_segment.texture = segment_texture
	new_segment.modulate = default_segment_modulate_color
	
	return new_segment

func update_segment_count() -> void:
	for segment in segment_container.get_children():
		segment.queue_free()
	
	segments_list.clear() 
	
	var segment_count = get_segment_count()
	for i in segment_count:
		var tmp_segment = create_segment();
		segments_list.push_back(tmp_segment);
		segment_container.add_child(tmp_segment);

func fill_segment(index :int) -> void:
	segments_list[index].modulate = default_segment_modulate_color

func empty_segment(index :int) -> void:
	segments_list[index].modulate = empty_segment_modulate_color

func get_segment_count() -> int:
	return floor(player_node.max_stamina / player_node.stamina_usage)

func get_loading_segment_index() -> int:
	var segment_index = floor(player_node.current_stamina / player_node.stamina_usage)
	if segment_index >= get_segment_count():
		return -1
	return segment_index

func _process(delta: float) -> void:
	if player_node == null:
		return
	
	if player_node.stamina_locked:
		return
	
	flashing_timer += delta * loading_flash_speed
	var loading_segment_index = get_loading_segment_index();
	if not loading_segment_index == -1:
		segments_list[loading_segment_index].modulate = lerp(default_segment_modulate_color, empty_segment_modulate_color, (sin(flashing_timer)+1.0)/2.0);
	
	if loading_segment_index == -1:
		loading_segment_index = get_segment_count();
	
	for segment_index in segments_list.size():
		var tmp_color := default_segment_modulate_color
		if not loading_segment_index == -1:
			if segment_index > loading_segment_index:
				tmp_color = empty_segment_modulate_color
		if segment_index != loading_segment_index:
			segments_list[segment_index].modulate = tmp_color
