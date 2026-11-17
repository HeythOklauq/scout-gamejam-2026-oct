extends Node3D
class_name UIController

@onready var hud_control: HUDControl = %HUDControl
@onready var shop_menu_screen: ShopScreenNode = %ShopMenuScreen
@onready var pause_screen: PauseScreenControl = %PauseScreen

@onready var dash_texture_rect: TextureRect = $SubViewportContainer/SubViewport/DashTextureRect
var dashlines_disappearance_speed := 3.0

var active_ui

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	GameplayManager.dashing_changed.connect(_on_dashing_changed)
	dash_texture_rect.modulate.a = 0.0
	show_pause()

func _on_dashing_changed() -> void:
	if GameplayManager.dashing:
		dash_texture_rect.modulate.a = 1.0

func _process(delta: float) -> void:
	if GameplayManager.dashing == false and dash_texture_rect.modulate.a > 0.0:
		dash_texture_rect.modulate.a = max(0.0, dash_texture_rect.modulate.a - delta * dashlines_disappearance_speed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		if hud_control.visible:
			show_pause()
		else:
			active_ui.go_back()
		get_tree().root.get_viewport().set_input_as_handled()

func _show_menu(menu :Control) -> void:
	prints("UIController - _show_menu", menu)
	if not menu == null:
		menu.visible = true;
	active_ui = menu
	if not hud_control == null:
		hud_control.visible = false;
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SlowMotionManager.pause_time()

func _hide_menu() -> void:
	prints("UIController - _hide_menu")
	if not hud_control == null:
		hud_control.visible = true;
	
	if not pause_screen == null:
		pause_screen.visible = false;
	
	if not shop_menu_screen == null:
		shop_menu_screen.visible = false;
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SlowMotionManager.resume_time()

func show_pause() -> void:
	GameplayManager.save_data();
	_show_menu(pause_screen)

func show_shop(shop_products :Array[GameplayManager.UNLOCKABLE_TYPES]) -> void:
	shop_menu_screen.product_types = shop_products;
	shop_menu_screen.update_shop()
	_show_menu(shop_menu_screen)

func _on_shop_menu_screen_close_pressed() -> void:
	_hide_menu()

func _on_pause_screen_resume_game() -> void:
	_hide_menu()
