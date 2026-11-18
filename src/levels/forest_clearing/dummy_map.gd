extends BaseLevel
class_name WorldLevel

var _autosave_timer: Timer
var _autosave_timer_duration := 60.0

func _ready() -> void:
	GameplayManager.load_data()
	initialize_autosave_timer.call_deferred()

func initialize_autosave_timer() -> void:
	_autosave_timer = Timer.new();
	_autosave_timer.wait_time = _autosave_timer_duration
	_autosave_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	_autosave_timer.ignore_time_scale = true
	
	_autosave_timer.timeout.connect(_on_autosave_timer_timeout)
	add_child(_autosave_timer)
	reset_autosave_timer()


func reset_autosave_timer() -> void:
	_autosave_timer.start()

func _on_autosave_timer_timeout() -> void:
	prints("AUTOSAVE")
	GameplayManager.save_data()
