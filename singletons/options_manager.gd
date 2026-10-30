extends Node

func _ready() -> void:
	call_deferred("load_data");

#region SAVE DATA
var option_file_path :String = "user://options.json"

func load_data() -> void:
	if FileAccess.file_exists(option_file_path):
		var file = FileAccess.open(option_file_path, FileAccess.READ)
		var file_content = file.get_as_text()
		file.close()
		
		var file_parsed = JSON.parse_string(file_content)
		load_audio_options(file_parsed.audio)

func save_data() -> void:
	prints("save_data")
	var file = FileAccess.open(option_file_path, FileAccess.WRITE_READ)
	var option_data = JSON.stringify({ "audio": get_audio_options() })
	file.store_string(option_data)
	file.close()
#endregion

#region AUDIO PARAMETERS
enum AUDIO_BUSES {
	MASTER,
	BGM,
	SFX,
	AMBIANT
}

func get_bus_name(audio_bus :AUDIO_BUSES) -> String:
	return AudioServer.get_bus_name(audio_bus);

func set_audio_level(audio_bus :AUDIO_BUSES, volume_linear :float) -> void:
	AudioServer.set_bus_volume_linear(audio_bus, volume_linear);
	save_data()
func get_audio_level(audio_bus :AUDIO_BUSES) -> float:
	return AudioServer.get_bus_volume_linear(audio_bus);

func set_bus_mute(audio_bus :AUDIO_BUSES, muted :bool) -> void:
	AudioServer.set_bus_mute(audio_bus, muted);
	save_data()
func is_bus_mute(audio_bus :AUDIO_BUSES) -> bool:
	return AudioServer.is_bus_mute(audio_bus);

func get_audio_options() -> Array:
	var result = []
	for bus_index in AUDIO_BUSES.values():
		result.push_back({
			"volume": AudioServer.get_bus_volume_linear(bus_index),
			"mute": AudioServer.is_bus_mute(bus_index)
		})
	return result;

func load_audio_options(audio_options :Array) -> void:
	for bus_index in audio_options.size():
		var bus_data = audio_options[bus_index] as Dictionary
		
		AudioServer.set_bus_volume_linear(bus_index, bus_data["volume"])
		AudioServer.set_bus_mute(bus_index, bus_data["mute"])

#endregion
