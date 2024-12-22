extends CanvasLayer

@onready var start_button = %start_button
@onready var options_button = %options_button
@onready var leaderboard_button: TextureButton = %leaderboard_button

@onready var main: Control = %Main
@onready var options: Control = %Options

@onready var back_options_button = %option_back_button

@onready var master_vol_slider = %master_vol_slider
@onready var master_vol_text = %master_vol_text

@onready var sfx_vol_slider = %sfx_vol_slider
@onready var sfx_vol_text = %sfx_vol_text

@onready var music_vol_slider = %music_vol_slider
@onready var music_vol_text = %music_vol_text

var level_scene = SceneManager.MAIN_LEVEL
var fade_transition = preload("res://ui/scene_transitions/fade_transition.tscn")
#var audio_control = AudioControl
var scene_transition = SceneTransitionManager

var is_option_menu_open : bool

func _ready() -> void:
  #if (not audio_control.init_music):
    #audio_control._init_music(audio_control.theme)
  #else:
    #if (not audio_control.current_song == audio_control.theme):
      #audio_control._change_music(audio_control.theme, 1.5)
    #
  #leaderboard_button.pressed.connect(_on_leaderboard_button_pressed)
  #leaderboard_button.mouse_entered.connect(_on_options_button_mouse_entered)
  
  #set values for sliders
  #master_vol_slider.value = audio_control._get_volume_normalized(audio_control.audio_bus_type.MASTER)
  #sfx_vol_slider.value = audio_control._get_volume_normalized(audio_control.audio_bus_type.SFX)
  #music_vol_slider.value = audio_control._get_volume_normalized(audio_control.audio_bus_type.MUSIC)
  #
  options.hide()

func _on_leaderboard_button_pressed():
  #ui_audio._confirm()
  SceneTransitionManager.change_scene_with_transition(SceneManager.LEADERBOARD, SceneManager.CIRCLE_TRANSITION)

func _on_start_button_pressed() -> void:
  #ui_audio._confirm()
  scene_transition.change_scene_with_transition(level_scene, fade_transition)
  #audio_control._change_music(audio_control.level_light, 1.5)

func _on_start_button_mouse_entered() -> void:
  #ui_audio._hover()
  pass

func _on_options_button_pressed() -> void:
    #ui_audio._confirm()
  pass

func _on_options_button_mouse_entered() -> void:
  #ui_audio._hover()
  pass

func _on_master_vol_slider_mouse_entered() -> void:
  #ui_audio._hover()
  pass

func _on_master_vol_slider_drag_started() -> void:
  #ui_audio._confirm()
  pass

func _on_master_vol_slider_value_changed(value: float) -> void:
  #audio_control._set_volume(audio_control.audio_bus_type.MASTER, master_vol_slider.value)
  #ui_audio._hover()
  pass

func _on_option_back_button_mouse_entered() -> void:
  #ui_audio._hover()
  pass

func _on_option_back_button_pressed() -> void:
  #ui_audio._confirm()
  pass

func _on_options_button_button_up() -> void:
  main.hide()
  options.show()
  is_option_menu_open = false

func _on_option_back_button_button_up() -> void:
  options.hide()
  main.show()

func _on_sfx_vol_slider_value_changed(value: float) -> void:
  #audio_control._set_volume(audio_control.audio_bus_type.SFX, sfx_vol_slider.value)
  #ui_audio._hover()
  pass

func _on_music_vol_slider_value_changed(value: float) -> void:
  #audio_control._set_volume(audio_control.audio_bus_type.MUSIC, music_vol_slider.value)
  #ui_audio._hover()
  pass
