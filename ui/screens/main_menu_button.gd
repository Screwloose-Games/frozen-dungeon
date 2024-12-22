extends TextureButton

var CIRCLE_TRANSITION = SceneManager.CIRCLE_TRANSITION
var MAIN_MENU = SceneManager.MAIN_MENU
@onready var ui_audio: Node = %ui_audio

func _ready() -> void:
  button_up.connect(_on_button_up)
  mouse_entered.connect(_on_button_hover)

func _on_button_up():
  ui_audio._confirm()
  SceneTransitionManager.change_scene_with_transition(SceneManager.MAIN_MENU, CIRCLE_TRANSITION)

func _on_button_hover():
  ui_audio._hover()
