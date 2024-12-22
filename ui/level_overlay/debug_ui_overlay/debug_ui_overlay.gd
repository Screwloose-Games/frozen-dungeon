extends CanvasLayer

@export var show_debug :=false

@onready var fps_field: LineEdit = %FpsField

func _ready() -> void:
  visible = OS.is_debug_build() and show_debug
  fps_field.text_changed.connect(_on_fps_field_text_changed)

func _unhandled_input(event: InputEvent) -> void:
  if OS.is_debug_build():
    if event.is_action_pressed("debug"):
      visible = not visible

func _on_fps_field_text_changed(new_text: String) -> void:
  var new_fps = int(new_text)
  set_frame_rate(new_fps)

func set_frame_rate(new_fps: int = 30) -> void:
  Engine.max_fps = new_fps
