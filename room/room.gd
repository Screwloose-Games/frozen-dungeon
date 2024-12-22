@tool

extends Node2D
class_name Room

@export var cleared: bool = false:
    set(val):
        cleared = val

@export_group("Doors")
@export var up: bool = false:
    set(val):
        up = val
        if top_door_location:
            top_door_location.is_door = up

@export var right: bool = false:
    set(val):
        right = val
        if right_door_location:
            right_door_location.is_door = right

@export var down: bool = false:
    set(val):
        down = val
        if bottom_door_location:
            bottom_door_location.is_door = down

@export var left: bool = false:
    set(val):
        left = val
        if left_door_location:
            left_door_location.is_door = left

@export var paused: bool:
  set(val):
    paused = val
    if paused:
      process_mode = PROCESS_MODE_DISABLED
    else:
      process_mode = PROCESS_MODE_INHERIT

@onready var top_door_location: DoorLocation = %TopDoorLocation
@onready var right_door_location: DoorLocation = %RightDoorLocation
@onready var bottom_door_location: DoorLocation = %BottomDoorLocation
@onready var left_door_location: DoorLocation = %LeftDoorLocation
@onready var enemy_detector: Area2D = %EnemyDetector
@onready var room_checker_top: Area2D = %RoomCheckerTop
@onready var room_checker_right: Area2D = %RoomCheckerRight
@onready var room_checker_bottom: Area2D = %RoomCheckerBottom
@onready var room_checker_left: Area2D = %RoomCheckerLeft
@onready var walls: Node2D = %Walls

var room_enemies: Array[Node2D] = []

var has_room_above: bool:
    get:
        return room_checker_top.has_overlapping_areas()

var has_room_right: bool:
    get:
        return room_checker_right.has_overlapping_areas()

var has_room_bottom: bool:
    get:
        return room_checker_bottom.has_overlapping_areas()

var has_room_left: bool:
    get:
        return room_checker_left.has_overlapping_areas()


func _ready() -> void:
    await get_tree().process_frame
    up = has_room_above
    right = has_room_right
    down = has_room_bottom
    left = has_room_left
    room_enemies = enemy_detector.get_overlapping_bodies()
    setup_enemy_transform_callback()

func setup_enemy_transform_callback():
  for enemy: Minion in room_enemies:
    enemy.transformed.connect(_on_enemy_transformed)

func _on_enemy_transformed():
  if cleared:
    return
  var all_transformed = true
  for enemy: Minion in room_enemies:
    if enemy.is_alive:
      return
  cleared = true
  transform_room_to_hell()

func reset_room():
  pass

func reset_enemies():
  pass

func transform_room_to_hell():
  var tween = get_tree().create_tween()
  tween.tween_property(walls.material, "shader_parameter/strength", 0.0, 1.0)

func _on_player_entered_room(area: Area2D) -> void:
  paused = false
  
  pass # Replace with function body.


func _on_player_left_room(area: Area2D) -> void:
  paused = true
  if not cleared:
    reset_room()
