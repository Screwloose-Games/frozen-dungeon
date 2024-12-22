extends Node

signal paused(is_paused: bool)

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    get_tree().paused = not get_tree().paused
    paused.emit(get_tree().paused)
