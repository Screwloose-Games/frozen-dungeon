@tool
extends Node2D
class_name DoorLocation

@export var is_door: bool = false:
  set(val):
    is_door = val
    if is_node_ready():
      setup_children()

enum Direction {
  UP,
  RIGHT,
  DOWN,
  LEFT
}

@export var direction: Direction:
  set(val):
    direction = val
    if doorway:
      doorway.direction = direction
    match direction:
      Direction.UP:
        rotation = 0

      Direction.RIGHT:
        rotation = 0.5 * PI
      Direction.DOWN:
        rotation = PI

      Direction.LEFT:
        rotation = 1.5 * PI

@onready var blocked_doorway_top: StaticBody2D = %BlockedDoorwayTop

@onready var doorway: Doorway = %Doorway

func _ready():
  setup_children()

func setup_children():
  doorway.direction = direction
  if is_door:
      blocked_doorway_top.visible = false
      blocked_doorway_top.process_mode = Node.PROCESS_MODE_DISABLED
      doorway.visible = true
      doorway.process_mode = Node.PROCESS_MODE_INHERIT
  else:
      blocked_doorway_top.visible = true
      blocked_doorway_top.process_mode = Node.PROCESS_MODE_INHERIT
      doorway.visible = false
      doorway.process_mode = Node.PROCESS_MODE_DISABLED
