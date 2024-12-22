extends Node
class_name ActorCore

@export var starting_state: State
@onready var enemy: Minion = $".."

func _ready() -> void:
  enemy.initial_state
