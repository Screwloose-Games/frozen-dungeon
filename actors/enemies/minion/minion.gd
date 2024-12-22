extends Actor
class_name Minion

@export var config: MinionConfigResource = MinionConfigResource.new()
@export_range(0, 1) var transformation_progress: float = 1.0:
  set(val):
    transformation_progress = val
    material.set("shader_parameter/strength", transformation_progress)

@onready var hit_box_component: HitBoxComponent = $HitBoxComponent
@onready var hurt_box_component: HitBoxComponent = $HitBoxComponent
@onready var health_component: HealthComponent = %HealthComponent

@onready var wander_state: WanderState = %WanderState

signal transformed

var is_alive = true

var team := TeamUtils.Team.ENEMY

func _init(init_config: MinionConfigResource = config):
    config = init_config
    state_machine = StateMachine.new()

func _ready():
    state_machine.state = initial_state
    transformation_progress = transformation_progress

    assert(config != null)
    health_component.died.connect(_on_died)
    tree_exiting.connect(_on_tree_exiting)

func _on_died():
    state_machine.change_state(wander_state)
    is_alive = false
    remove_from_group("Enemy")
    #set_physics_process(false)
    #disable_collisions()
    animated_sprite_2d.play("death")
    var tween = get_tree().create_tween()
    tween.tween_property(self, "transformation_progress", 0, 1)
    #await animated_sprite_2d.animation_finished
    #await get_tree().create_timer(1).timeout
    transformed.emit()
    await tween.finished
    #queue_free.call_deferred()

func disable_collisions():
    hit_box_component.set_deferred("monitoring", false)
    hurt_box_component.set_deferred("monitorable", false)
    collision_layer = 0
    collision_mask = 0

func _physics_process(delta: float) -> void:
    state_machine.update(delta)

    #if animated_sprite_2d != null and not animated_sprite_2d.is_playing():
        #animated_sprite_2d.play("run")

func _on_tree_exiting():
    set_physics_process(false)
