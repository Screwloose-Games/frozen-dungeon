extends CanvasLayer

@onready var pause_menu_screen: Control = $PauseMenuScreen

@onready var reset_button: TextureButton = %ResetButton
@onready var pause_menu_button: Node = %PauseMenuButton
@onready var back_button: TextureButton = %BackButton
@onready var ui_audio: Node = %ui_audio
@onready var mobile_pause_button: TextureButton = %MobilePauseButton
@onready var main_menu_button: TextureButton = %MainMenuButton


func _ready() -> void:
  pause_menu_button.paused.connect(_on_paused)
  reset_button.pressed.connect(_on_restart_button_pressed)
  reset_button.mouse_entered.connect(_on_button_mouse_entered)
  main_menu_button.pressed.connect(_on_main_menu_button_pressed)
  main_menu_button.mouse_entered.connect(_on_button_mouse_entered)
  
  back_button.pressed.connect(_on_back_button_pressed)
  mobile_pause_button.pressed.connect(_on_mobile_pause_pressed)
  back_button.mouse_entered.connect(_on_button_mouse_entered)
  mobile_pause_button.visible = OSUtils.is_mobile()
  pause_menu_screen.visible = false

func _on_mobile_pause_pressed():
  get_tree().paused = true
  pause_menu_screen.visible = true
  mobile_pause_button.visible = false

func _on_paused(is_paused: bool):
  pause_menu_screen.visible = is_paused

func _on_back_button_pressed():
  ui_audio._confirm()
  pause_menu_screen.visible = false
  get_tree().paused = false
  mobile_pause_button.visible = OSUtils.is_mobile()

func _on_button_mouse_entered() -> void:
  ui_audio._hover()

func _on_restart_button_pressed():
  SceneTransitionManager.change_scene_with_transition(SceneManager.MAIN_LEVEL, SceneManager.FADE_TRANSITION)
  get_tree().paused = false

func _on_main_menu_button_pressed():
  SceneTransitionManager.change_scene_with_transition(SceneManager.MAIN_MENU, SceneManager.FADE_TRANSITION)
  get_tree().paused = false
