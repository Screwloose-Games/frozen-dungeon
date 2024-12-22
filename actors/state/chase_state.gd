extends State
class_name ChaseState

var target: Node2D
var actor: Actor

@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D


func _enter_tree() -> void:
    actor = owner # Assume actor is scene root
    get_target()

func get_target():
    target = get_tree().get_first_node_in_group("PlayerController")
    if navigation_agent_2d and target:
        navigation_agent_2d.target_position = target.global_position

func set_chase_target(new_target: Node2D):
    target = new_target
    if navigation_agent_2d:
        navigation_agent_2d.target_position = new_target.global_position

func enter(force: bool = false, data: Dictionary = {}):
    pass

func update(delta):
    if not navigation_agent_2d:
        return
    if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
        return
    navigation_agent_2d.set_target_position(target.global_position)
    if navigation_agent_2d.is_navigation_finished():
        navigation_agent_2d.set_target_position(target.global_position)
        return
    var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
    var new_velocity: Vector2 = actor.global_position.direction_to(next_path_position) * actor.speed
    #var direction = actor.global_position.direction_to(navigation_agent_2d.path_target_position)
    #var new_velocity = direction * actor.speed
    #actor.velocity = new_velocity
    #navigation_agent_2d.set_velocity(actor.velocity)
    #navigation_agent_2d.move_and_slide()

    #var direction = actor.global_position.direction_to(target.global_position)
    #var new_velocity = direction * actor.speed
    actor.velocity = new_velocity
    actor.move_and_slide()

func exit():
    actor.animated_sprite_2d.stop()
