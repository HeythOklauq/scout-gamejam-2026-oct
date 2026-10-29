extends Node

var hit_stop_timer :Timer = Timer.new();

var remaining_duration := 0.0;
var last_time_scale := 1.0;

const MINOR_SLOW := 0.6;
const STANDARD_SLOW := 0.3;
const MAJOR_SLOW := 0.1;

func _ready() -> void:
	hit_stop_timer.ignore_time_scale = true;
	hit_stop_timer.timeout.connect(on_timer_timeout);
	add_child(hit_stop_timer);

func slow_time(time_scale :float, duration :float) -> void:
	last_time_scale = time_scale
	Engine.time_scale = time_scale;
	hit_stop_timer.start(duration);

func pause_time() -> void:
	remaining_duration = hit_stop_timer.time_left
	if hit_stop_timer.is_stopped():
		remaining_duration = 0.0
	hit_stop_timer.stop()
	Engine.time_scale = 0.0;

func resume_time() -> void:
	if remaining_duration > 0.0:
		slow_time(last_time_scale, remaining_duration)
		return
	
	Engine.time_scale = 1.0;

func on_timer_timeout() -> void:
	Engine.time_scale = 1.0;
