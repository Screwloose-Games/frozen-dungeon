
extends Actor

@export var ranged_weapon_scene: PackedScene
@export var config: MinionConfigResource
@export var can_shoot: bool = true
@export var tagline_interval: float = 10.00
const EXPLOSION = preload("res://src/weapons/Explosion.tscn")

@onready var sword_hit_box_component = %SwordHitBoxComponent
@onready var hit_box_component = %HitBoxComponent
@onready var attack_animation_player = %AttackAnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var tagline_timer := Timer.new()
var state_sequence: Array[State] = []
var should_chase = true

var team := TeamUtils.Team.ENEMY

enum StateEnum {
    CHASE,
    SHOOT,
    MELEE
}

@onready var states: Dictionary = {
    StateEnum.CHASE: ChaseState.new(self, get_tree(), 2.0),
    StateEnum.SHOOT: ShootState.new(self, get_tree(), ranged_weapon_scene.instantiate(), 3.0),
    StateEnum.MELEE: MeleeState.new(self, get_tree(), "melee")
}

@onready var state_timer = $StateTimer

func _on_tagline_timer_timeout():
    audio_stream_player_2d.play()

func _ready():
    audio_stream_player_2d.play()
    add_child(tagline_timer)
    tagline_timer.start(tagline_interval)
    tagline_timer.timeout.connect(_on_tagline_timer_timeout)
    animation_player = %AnimationPlayer
    animated_sprite = %AnimatedSprite2D
    state_sequence.append_array(states.values())
    initial_state = state_sequence[0]
    state_machine = StateMachine.new()
    state_completed.connect(_on_state_completed)
    died.connect(_on_died)

func _on_state_completed():
    should_chase = !should_chase

func explode():
    var explosion_scene = EXPLOSION.instantiate()
    explosion_scene.global_position = global_position
    GameStats.world.add_child.call_deferred(explosion_scene)

func _on_died():
    GameStats.boss_died.emit(self)
    explode()
    queue_free.call_deferred()

func _physics_process(delta):
    var player = get_tree().get_first_node_in_group("Player")
    if should_chase:
        var chase_state = states[StateEnum.CHASE]
        chase_state.set_chase_target(player)
        state_machine.change_state(chase_state)
    else:
        var melee_state = states[StateEnum.MELEE]
        state_machine.change_state(melee_state)
    state_machine.update(delta)
    move_and_slide()
