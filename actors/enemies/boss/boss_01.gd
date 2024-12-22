class_name Boss
extends Actor

@export var ranged_weapon_scene: PackedScene
@export var config: MinionConfigResource
@export var can_shoot: bool = true
@export var tagline_interval: float = 10.00
@export var melee_attack_range: float = 10.0
const EXPLOSION = preload("res://src/weapons/Explosion.tscn")

@onready var sword_hit_box_component = %SwordHitBoxComponent
@onready var sword_hit_box_component_checker: Area2D = %SwordHitBoxComponentChecker

@onready var hit_box_component = %HitBoxComponent
@onready var attack_animation_player = %AttackAnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var melee_attack_marker = %MeleeAttackMarker
@onready var ranged_weapon = %Weapon


var tagline_timer := Timer.new()

var should_chase := true
var currently_attacking := false

var team := TeamUtils.Team.ENEMY

enum StateEnum {
    CHASE,
    SHOOT,
    MELEE
}

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var states: Dictionary = {
    StateEnum.SHOOT: ShootState.new(self, get_tree(), ranged_weapon, 3.0),
    StateEnum.CHASE: ChaseState.new(self, get_tree(), 2.0, melee_attack_marker, player),
    StateEnum.MELEE: MeleeState.new(self, get_tree(), "melee")
}

@onready var state_sequence: Array[State] = []
var state_index: int = 0
func get_next_state() -> State:
    state_index += 1
    if state_index >= state_sequence.size():
        state_index = 0
    return state_sequence[state_index]

@onready var state_timer = $StateTimer

func _on_tagline_timer_timeout():
    audio_stream_player_2d.play()

func _ready():
    state_sequence.append_array(states.values())
    initial_state = state_sequence[0]
    audio_stream_player_2d.play()
    add_child(tagline_timer)
    tagline_timer.start(tagline_interval)
    tagline_timer.timeout.connect(_on_tagline_timer_timeout)
    animation_player = %AnimationPlayer
    animated_sprite = %AnimatedSprite2D
    state_machine = StateMachine.new()
    state_completed.connect(_on_state_completed)
    died.connect(_on_died)
    state_machine.change_state(initial_state, true)

func _on_state_completed():
    #should_chase = !should_chase
    var next_state = get_next_state()
    state_machine.change_state(next_state, true)
    print("Changed state to:", next_state.name)

func explode():
    var explosion_scene = EXPLOSION.instantiate()
    explosion_scene.global_position = global_position
    GameStats.world.add_child.call_deferred(explosion_scene)

func _on_died():
    GameStats.boss_died.emit(self)
    explode()
    queue_free.call_deferred()

func on_attack():
    currently_attacking = true
    await state_completed
    currently_attacking = false

func _physics_process(delta):
    state_machine.update(delta)
    move_and_slide()
    return
    if currently_attacking:
        move_and_slide()
        return

    var player: Player = get_tree().get_first_node_in_group("Player")
    var attack_distance_to_player = player.global_position.distance_to(melee_attack_marker.global_position)
    var player_is_within_melee_range = sword_hit_box_component_checker.overlaps_area(player.hurt_box_component)
    if player_is_within_melee_range:
        var melee_state: MeleeState = states[StateEnum.MELEE]
        state_machine.change_state(melee_state, true)
        on_attack()
    else:
        var chase_state: ChaseState = states[StateEnum.CHASE]
        chase_state.set_chase_target(player)
        state_machine.change_state(chase_state)
    state_machine.update(delta)
    move_and_slide()
