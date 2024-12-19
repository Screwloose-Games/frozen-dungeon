## Allows the actor to roll to a location 
extends Node
class_name RollAbilityComponent

## The actor that executes the roll
@export var actor: CharacterBody2D
@export var max_roll_distance: float = 100.0  # Roll distance in pixels
@export var time_to_finish: float = 0.75  # Duration of the roll

signal started_rolling
signal finished_rolling

var roll_target: Vector2 = Vector2.ZERO
var is_rolling: bool = false
var roll_direction: Vector2 = Vector2.ZERO
var roll_timer: float = 0.0
var initial_position: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
  if is_rolling:
    roll(delta)
  if Input.is_action_just_pressed("roll"):
    start_rolling()

func start_rolling():
    if is_rolling:
        return  # Prevent multiple rolls at the same time
    
    roll_target = get_roll_target()
    initial_position = actor.global_position
    roll_direction = (roll_target - initial_position).normalized()
    
    roll_timer = 0.0
    is_rolling = true
    started_rolling.emit()
    
    actor.velocity = roll_direction * (max_roll_distance / time_to_finish)

func roll(delta: float):
    roll_timer += delta

    # Move the actor with its velocity
    actor.move_and_slide()

    # Check if the actor has overshot the roll target
    if actor.global_position.distance_to(initial_position) >= max_roll_distance:
        stop_rolling()
    if actor.global_position.distance_to(roll_target) <= 1.0:
        stop_rolling()
        #actor.global_position = roll_target  # Snap exactly to the target position

func stop_rolling():
    is_rolling = false
    roll_timer = 0.0
    actor.velocity = Vector2.ZERO  # Stop movement
    finished_rolling.emit()

func get_roll_target() -> Vector2:
    # Convert mouse position from screen space to world space
    
    var mouse_position = actor.get_global_mouse_position()
    var target = actor.global_position.move_toward(mouse_position, max_roll_distance)
    return target
