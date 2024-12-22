extends State
class_name WanderState

var actor: Actor
var idle_time: float = 2.0 # Time to idle in seconds
var wander_time: float = 3.0 # Time to wander in seconds
var time_elapsed: float = 0.0
var is_idling: bool = false
var wander_distance: float = 4.0
var wander_direction: Vector2 = Vector2.ZERO # Store the direction for wandering
var target: Vector2


@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D

func enter(force: bool = false, data: Dictionary = {}):
    actor = owner
    time_elapsed = 0.0
    is_idling = false
    wander_direction = Vector2.ZERO
    actor.velocity = Vector2.ZERO
    actor.animated_sprite_2d.play("walk") # Play walking animation

func get_random_point() -> Vector2:
    # Replace this with the logic for generating a random point
    # For example, within a specific rectangular area:
    var x_range: float = wander_distance
    var y_range: float = wander_distance
    return Vector2(
        randf_range(0, x_range), 
        randf_range(0, y_range)
    )

func set_random_target():
    var random_point: Vector2 = get_random_point()
    navigation_agent_2d.set_target_position(random_point)
    #var try_count := 15
    while not navigation_agent_2d.is_target_reachable():
        random_point = get_random_point()
    target = random_point

func update(delta):
    time_elapsed += delta

    if is_idling:
        # Idle state
        if time_elapsed >= idle_time:
            time_elapsed = 0.0
            is_idling = false
            wander_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
            actor.animated_sprite_2d.play("walk") # Resume walking
    else:
        # Wandering state
        if wander_direction == Vector2.ZERO:
            # Calculate a new random direction only once
            wander_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
        if not navigation_agent_2d:
          return
        if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
            return
        target = get_random_point()
        navigation_agent_2d.set_target_position(target)
        if navigation_agent_2d.is_navigation_finished():
            navigation_agent_2d.set_target_position(target)
            return
        var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
        var new_velocity: Vector2 = actor.global_position.direction_to(next_path_position) * actor.speed
            #var new_velocity = wander_direction * actor.speed
        actor.velocity = new_velocity
        actor.move_and_slide()

        if time_elapsed >= wander_time:
            time_elapsed = 0.0
            is_idling = true
            wander_direction = Vector2.ZERO # Reset direction for next wander phase
            actor.velocity = Vector2.ZERO
            actor.animated_sprite_2d.play("idle") # Switch to idle animation

func exit():
    actor.animated_sprite_2d.stop()
    actor.velocity = Vector2.ZERO
