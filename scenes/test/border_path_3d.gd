extends Path3D
class_name BorderPath3D

@export var TEXTURE_LIST :Array[Texture2D] = [];
@export var sprite_count := 50
@export var sprite_scale := 4.0

func _ready() -> void:
	call_deferred("initialize");

func create_border_sprite() -> PathFollow3D:
	var tmp_path_follow := PathFollow3D.new();
	
	var tmp_sprite := Sprite3D.new();
	var target_texture := TEXTURE_LIST.pick_random() as Texture2D;
	tmp_sprite.texture = target_texture
	tmp_sprite.rotation_degrees.y = 90.0
	tmp_sprite.scale = Vector3.ONE * sprite_scale
	# tmp_sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	
	tmp_path_follow.add_child(tmp_sprite);
	tmp_sprite.offset.y = target_texture.get_size().y / 3.0
	
	return tmp_path_follow

func reset() -> void:
	for child in get_children():
		child.queue_free()

func initialize() -> void:
	reset()
	for i in sprite_count:
		var tmp_path_follow = create_border_sprite()
		prints(tmp_path_follow.name)
		add_child(tmp_path_follow)
		tmp_path_follow.progress_ratio = i/float(sprite_count-1)
