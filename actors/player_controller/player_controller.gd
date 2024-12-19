extends CharacterBody2D

class_name PlayerController

# Agreed on speed 30?

@export var attack_time: float = 0.5
@export_range(0.0, 400.0) var SPEED: float = 50.0
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var interact_area = %InteractArea
@onready var roll_component: RollAbilityComponent = %RollComponent
@onready var attack_animated_sprite_2d: AnimatedSprite2D = %AttackAnimatedSprite2D

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


func _ready() -> void:
  animated_sprite_2d.play("run")

func _physics_process(delta):
    if roll_component.is_rolling:
        return
    var input_direction = Input.get_vector("left", "right", "up", "down")
    if input_direction and can_move:
        if not is_attacking and not animated_sprite_2d.is_playing():
            animated_sprite_2d.play("run")
        velocity = input_direction * SPEED
    else:
      if not is_attacking:
          animated_sprite_2d.pause()
      velocity = lerp(velocity, Vector2.ZERO, 0.1)

    move_and_slide()

func blow_fire():
  var translation = Vector2(24, -20) 
  animated_sprite_2d.play.call_deferred("fire")
  var local_fire: AnimatedSprite2D = attack_animated_sprite_2d.duplicate()
  attack_animated_sprite_2d.add_sibling.call_deferred(local_fire)
  local_fire.set_global_transform.call_deferred(animated_sprite_2d.global_transform)
  local_fire.set_global_position.call_deferred(animated_sprite_2d.global_position + translation)
  local_fire.top_level = true
  local_fire.play.call_deferred("fire")
  local_fire.set_visible.call_deferred(true)
  await local_fire.animation_finished
  local_fire.queue_free.call_deferred()

func attack():
  animated_sprite_2d.stop()
  blow_fire()
  #await get_tree().create_timer(attack_time).timeout
  await animated_sprite_2d.animation_finished
  animated_sprite_2d.stop()
  is_attacking = false
  #animated_sprite_2d.play("run")

func _input(event: InputEvent) -> void:
  if can_attack:
    if event.is_action_pressed("attack"):
      is_attacking = true
      attack()
