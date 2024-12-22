# PlayerController.gd
extends CharacterBody2D
class_name PlayerController

@export_range(0.0, 400.0) var speed: float = 50.0
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var interact_area = %InteractArea
@onready var roll_component = %Roll
@onready var attack_animated_sprite_2d: AnimatedSprite2D = %AttackAnimatedSprite2D

# Variables
var last_facing_direction: Vector2 = Vector2.RIGHT
var input_direction: Vector2 = Vector2.ZERO

enum PlayerState {
  IDLE,
  WALKING,
  ATTACKING
}


var state: PlayerState = PlayerState.WALKING

var can_move: bool = true
var is_attacking := false
var can_attack: bool = true:
  get:
    return not is_attacking



func _physics_process(delta):
    # Handle player input
    input_direction = Input.get_vector("left", "right", "up", "down")

    # Handle movement and roll
    if not roll_component.is_rolling:
        handle_movement_input()

    # Pass through velocity to move_and_slide
    move_and_slide()

func handle_movement_input():
    # Handle movement when not rolling
    if input_direction != Vector2.ZERO:
        last_facing_direction = input_direction.normalized()
        velocity = input_direction * speed  # Example walk speed
    else:
        velocity = Vector2.ZERO

func should_roll() -> bool:
    # Check if roll action is pressed
    return Input.is_action_just_pressed("roll")

func get_roll_direction() -> Vector2:
    # Return the current input direction for rolling
    return input_direction.normalized()

func get_last_facing_direction() -> Vector2:
    return last_facing_direction

func on_roll_start():
    # Optional: Disable other inputs during roll
    velocity = Vector2.ZERO

func on_roll_end():
    # Optional: Reset state after roll
    velocity = Vector2.ZERO
