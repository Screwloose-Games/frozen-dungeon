# RollComponent.gd
extends Node

# Constants
@export var ROLL_SPEED = 200
@export var ROLL_DURATION = 0.3
@export var ROLL_COOLDOWN = 1.0

# Variables
var is_rolling = false
var can_roll = true
var roll_direction = Vector2.ZERO
var roll_timer = 0.0
var cooldown_timer = 0.0

# Reference to the parent PlayerController
var player_controller: Node = null

func _ready():
    # Ensure the parent is a PlayerController
    player_controller = get_parent()
    assert(player_controller != null and player_controller is CharacterBody2D, "RollComponent must be a child of a CharacterBody2D")

func _physics_process(delta):
    # Roll logic is triggered by the parent
    if not is_rolling and can_roll and player_controller.should_roll():
        start_roll()

    if is_rolling:
        perform_roll(delta)

    if not can_roll:
        update_cooldown(delta)

func start_roll():
    # Get direction from parent (PlayerController)
    roll_direction = player_controller.get_roll_direction()
    if roll_direction == Vector2.ZERO:
        roll_direction = player_controller.get_last_facing_direction()

    is_rolling = true
    can_roll = false
    roll_timer = ROLL_DURATION
    cooldown_timer = ROLL_COOLDOWN

    # Inform the parent that rolling has started
    player_controller.on_roll_start()

func perform_roll(delta):
    # Apply roll movement
    var velocity = roll_direction * ROLL_SPEED
    player_controller.velocity = velocity  # Update the parent's velocity
    player_controller.move_and_slide()

    roll_timer -= delta
    if roll_timer <= 0.0:
        end_roll()

func end_roll():
    is_rolling = false
    player_controller.on_roll_end()

func update_cooldown(delta):
    cooldown_timer -= delta
    if cooldown_timer <= 0.0:
        can_roll = true
